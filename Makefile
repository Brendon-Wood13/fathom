# Fathom - Static Site Build & Deploy
# Deploys as a subdirectory of woodcloud.org: woodcloud.org/fathom/

.PHONY: help build deploy clean dev

# =============================================================================
# CONFIGURATION — Uses existing woodcloud.org infrastructure
# =============================================================================

BUCKET_NAME = brendonawoodweb
S3_PREFIX = fathom
AWS_REGION = us-east-1
CLOUDFRONT_DISTRIBUTION_ID = E297YBZKQ7XW9P

DIST_DIR = dist

# Colors
BLUE := \033[0;34m
GREEN := \033[0;32m
YELLOW := \033[1;33m
RED := \033[0;31m
NC := \033[0m

# =============================================================================
# COMMANDS
# =============================================================================

help: ## Show this help
	@echo -e "$(BLUE)Fathom - Static Site Build & Deploy$(NC)"
	@echo -e "$(BLUE)Deploys to: woodcloud.org/fathom/$(NC)"
	@echo ""
	@echo "  make build    Build site into dist/"
	@echo "  make deploy   Build + deploy to S3 + invalidate CloudFront"
	@echo "  make dev      Serve locally for development"
	@echo "  make clean    Remove dist/"
	@echo ""

build: clean ## Build deployable site into dist/
	@echo -e "$(BLUE)Building site...$(NC)"
	@mkdir -p $(DIST_DIR)/docs $(DIST_DIR)/images
	cp site/index.html $(DIST_DIR)/
	cp renderer/index.html $(DIST_DIR)/reader.html
	cp fathom-templates/*.fathom $(DIST_DIR)/docs/
	cp images/*.png images/*.jpg $(DIST_DIR)/images/ 2>/dev/null || true
	@echo -e "$(GREEN)Build complete: $(DIST_DIR)/$(NC)"

deploy: build _check-aws ## Build + deploy to woodcloud.org/fathom/
	@echo -e "$(BLUE)Deploying to s3://$(BUCKET_NAME)/$(S3_PREFIX)/...$(NC)"
	aws s3 sync $(DIST_DIR)/ s3://$(BUCKET_NAME)/$(S3_PREFIX)/ --delete --region $(AWS_REGION)
	@echo -e "$(YELLOW)Invalidating CloudFront cache...$(NC)"
	aws cloudfront create-invalidation --distribution-id $(CLOUDFRONT_DISTRIBUTION_ID) --paths "/$(S3_PREFIX)/*" --output table
	@echo -e "$(GREEN)Deployed to woodcloud.org/$(S3_PREFIX)/$(NC)"

dev: build ## Serve locally for development
	@echo -e "$(BLUE)Serving at http://localhost:8000$(NC)"
	cd $(DIST_DIR) && python3 -m http.server 8000

clean: ## Remove build artifacts
	@rm -rf $(DIST_DIR)

# =============================================================================
# INTERNAL
# =============================================================================

_check-aws:
	@aws sts get-caller-identity >/dev/null 2>&1 || (echo -e "$(RED)AWS CLI not configured. Run 'aws configure' first.$(NC)"; exit 1)
