#!/bin/bash
# =============================================================================
# RIFT Documentation Repository Cleanup & Reorganization Scripts
# Repository: github.com/obinexus/riftdoc
# OBINexus Session Continuity: MAINTAINED
# =============================================================================

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
REPO_ROOT="$(pwd)"
BACKUP_DIR="${REPO_ROOT}/backup_$(date +%Y%m%d_%H%M%S)"
LOG_FILE="${REPO_ROOT}/cleanup_$(date +%Y%m%d_%H%M%S).log"

# OBINexus Session Continuity Markers
OBINEXUS_SESSION_ID="rift-cleanup-$(date +%Y%m%d)"
MIGRATION_TAG="v2.0.0-stage-bound-$(date +%Y%m%d)"

# Logging function
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}" | tee -a "$LOG_FILE"
}

error() {
    echo -e "${RED}[ERROR] $1${NC}" | tee -a "$LOG_FILE"
    exit 1
}

warn() {
    echo -e "${YELLOW}[WARN] $1${NC}" | tee -a "$LOG_FILE"
}

info() {
    echo -e "${BLUE}[INFO] $1${NC}" | tee -a "$LOG_FILE"
}

# =============================================================================
# PHASE 1: BACKUP AND PREPARATION
# =============================================================================

create_backup() {
    log "Creating backup of current repository state..."
    mkdir -p "$BACKUP_DIR"
    
    # Copy all files except .git using standard Unix commands
    find "$REPO_ROOT" -type f ! -path "*/.git/*" ! -path "*/backup_*/*" | while read -r file; do
        # Get relative path
        rel_path="${file#$REPO_ROOT/}"
        target_dir="$BACKUP_DIR/$(dirname "$rel_path")"
        
        # Create target directory if it doesn't exist
        mkdir -p "$target_dir"
        
        # Copy file
        cp "$file" "$BACKUP_DIR/$rel_path"
    done
    
    log "Backup created at: $BACKUP_DIR"
}

# =============================================================================
# PHASE 2: STAGE-BOUND DIRECTORY STRUCTURE CREATION
# =============================================================================

create_stage_bound_structure() {
    log "Creating stage-bound directory structure..."
    
    # Main documentation structure
    mkdir -p docs/{stages,toolchain,build-orchestration,compliance,specifications,examples}
    
    # Stage directories (0-6)
    for stage in {0..6}; do
        case $stage in
            0) stage_name="stage-0-tokenizer" ;;
            1) stage_name="stage-1-parser" ;;
            2) stage_name="stage-2-ast" ;;
            3) stage_name="stage-3-validator" ;;
            4) stage_name="stage-4-bytecode" ;;
            5) stage_name="stage-5-verifier" ;;
            6) stage_name="stage-6-emitter" ;;
        esac
        
        mkdir -p "docs/stages/${stage_name}"/{specifications,examples,implementation}
        
        # Create stage README template
        cat > "docs/stages/${stage_name}/README.md" << EOF
# RIFT Stage ${stage}: ${stage_name##*-}

## Overview
Documentation for RIFT compilation pipeline Stage ${stage}.

## Architecture
- **Input**: $(get_stage_input $stage)
- **Process**: $(get_stage_process $stage)
- **Output**: $(get_stage_output $stage)

## Contents
- [Specifications](specifications/)
- [Examples](examples/)
- [Implementation](implementation/)

## OBINexus Compliance
- Toolchain: riftlang.exe → .so.a → rift.exe → gosilang
- Build Stack: nlink → polybuild
- Policy: #NoGhosting + OpenSense

---
*Part of the RIFT ecosystem documentation - Session ID: ${OBINEXUS_SESSION_ID}*
EOF
    done
    
    # Toolchain structure
    mkdir -p docs/toolchain/{riftlang-exe,shared-objects,rift-exe,gosilang}
    
    # Build orchestration structure
    mkdir -p docs/build-orchestration/{nlink,polybuild}
    
    # Compliance structure
    mkdir -p docs/compliance/{legal-policy,opensense,governance}
    
    # Specifications structure
    mkdir -p docs/specifications/{latex-specs,markdown-repos,compliance-scripts}
    
    # Examples structure
    mkdir -p docs/examples/{proof-of-concept,cultural-adaptation,integration}
    
    log "Stage-bound structure created successfully"
}

get_stage_input() {
    case $1 in
        0) echo "Source code text" ;;
        1) echo "Token stream" ;;
        2) echo "Parse tree" ;;
        3) echo "AST nodes" ;;
        4) echo "Validated AST" ;;
        5) echo "Bytecode" ;;
        6) echo "Verified bytecode" ;;
    esac
}

get_stage_process() {
    case $1 in
        0) echo "Lexical analysis & tokenization" ;;
        1) echo "Syntax parsing & grammar validation" ;;
        2) echo "AST construction & optimization" ;;
        3) echo "Semantic validation & constraint checking" ;;
        4) echo "Bytecode generation & IR optimization" ;;
        5) echo "Integrity verification & safety validation" ;;
        6) echo "Target emission & cultural adaptation" ;;
    esac
}

get_stage_output() {
    case $1 in
        0) echo "Token stream" ;;
        1) echo "Parse tree" ;;
        2) echo "Abstract Syntax Tree" ;;
        3) echo "Validated AST" ;;
        4) echo "Intermediate bytecode" ;;
        5) echo "Verified bytecode" ;;
        6) echo "Target code (C, Python, etc.)" ;;
    esac
}

# =============================================================================
# PHASE 3: FILE CATEGORIZATION AND MIGRATION
# =============================================================================

categorize_file() {
    local file="$1"
    local content=""
    
    # Read file content safely
    if [[ -f "$file" ]]; then
        content=$(head -20 "$file" 2>/dev/null | tr '[:upper:]' '[:lower:]' || echo "")
    fi
    
    local filename=$(basename "$file" | tr '[:upper:]' '[:lower:]')
    
    # Stage-based categorization logic
    if [[ $content =~ (token|lexical|scanner|lex) || $filename =~ (token|lex) ]]; then
        echo "docs/stages/stage-0-tokenizer"
    elif [[ $content =~ (parse|grammar|syntax|yacc|bison) || $filename =~ (parse|grammar) ]]; then
        echo "docs/stages/stage-1-parser"
    elif [[ $content =~ (ast|tree|node|abstract.*syntax) || $filename =~ (ast|tree) ]]; then
        echo "docs/stages/stage-2-ast"
    elif [[ $content =~ (valid|constraint|check|semantic) || $filename =~ (valid|check) ]]; then
        echo "docs/stages/stage-3-validator"
    elif [[ $content =~ (bytecode|ir|intermediate|llvm) || $filename =~ (bytecode|ir) ]]; then
        echo "docs/stages/stage-4-bytecode"
    elif [[ $content =~ (verify|integrity|safety|proof) || $filename =~ (verify|proof) ]]; then
        echo "docs/stages/stage-5-verifier"
    elif [[ $content =~ (emit|generate|target|cultural|accessibility) || $filename =~ (emit|generate|cultural) ]]; then
        echo "docs/stages/stage-6-emitter"
    elif [[ $content =~ (riftlang|compiler) || $filename =~ (riftlang) ]]; then
        echo "docs/toolchain/riftlang-exe"
    elif [[ $content =~ (gosilang|gosi) || $filename =~ (gosilang|gosi) ]]; then
        echo "docs/toolchain/gosilang"
    elif [[ $content =~ (\.so\.a|shared.*object) || $filename =~ (\.so\.a|shared) ]]; then
        echo "docs/toolchain/shared-objects"
    elif [[ $content =~ (rift\.exe|runtime) || $filename =~ (rift\.exe|runtime) ]]; then
        echo "docs/toolchain/rift-exe"
    elif [[ $content =~ (nlink|linking) || $filename =~ (nlink|link) ]]; then
        echo "docs/build-orchestration/nlink"
    elif [[ $content =~ (polybuild|build.*system) || $filename =~ (polybuild|build) ]]; then
        echo "docs/build-orchestration/polybuild"
    elif [[ $content =~ (legal|policy|ghost|noghost) || $filename =~ (legal|policy) ]]; then
        echo "docs/compliance/legal-policy"
    elif [[ $content =~ (opensense|recruitment) || $filename =~ (opensense) ]]; then
        echo "docs/compliance/opensense"
    elif [[ $content =~ (governance|audit) || $filename =~ (governance) ]]; then
        echo "docs/compliance/governance"
    elif [[ $content =~ (latex|\.tex|formal.*spec) || $filename =~ (\.tex|latex) ]]; then
        echo "docs/specifications/latex-specs"
    elif [[ $content =~ (compliance.*script|validation.*tool) || $filename =~ (script|tool) ]]; then
        echo "docs/specifications/compliance-scripts"
    elif [[ $content =~ (proof.*concept|poc|demo) || $filename =~ (poc|demo|proof) ]]; then
        echo "docs/examples/proof-of-concept"
    elif [[ $content =~ (cultural|chinese|korean|japanese|accessibility) || $filename =~ (cultural|accessibility) ]]; then
        echo "docs/examples/cultural-adaptation"
    elif [[ $content =~ (integration|end.*to.*end) || $filename =~ (integration|e2e) ]]; then
        echo "docs/examples/integration"
    else
        # Default fallback based on file location or type
        if [[ $file =~ /spec/ ]]; then
            echo "docs/specifications/markdown-repos"
        elif [[ $file =~ /reference/ ]]; then
            echo "docs/specifications/markdown-repos"
        else
            echo "docs/examples/proof-of-concept"
        fi
    fi
}

migrate_files() {
    log "Starting file migration process..."
    
    local migrated_count=0
    local total_files=0
    
    # Process all documentation files
    find . -type f \( -name "*.md" -o -name "*.pdf" -o -name "*.txt" -o -name "*.tex" \) \
        ! -path "./docs/*" \
        ! -path "./.git/*" \
        ! -path "./backup_*/*" | while read -r file; do
        
        total_files=$((total_files + 1))
        
        local target_dir=$(categorize_file "$file")
        local filename=$(basename "$file")
        
        # Ensure target directory exists
        mkdir -p "$target_dir"
        
        # Handle filename conflicts
        local target_file="$target_dir/$filename"
        local counter=1
        while [[ -f "$target_file" ]]; do
            local base="${filename%.*}"
            local ext="${filename##*.}"
            if [[ "$base" == "$filename" ]]; then
                target_file="$target_dir/${filename}_${counter}"
            else
                target_file="$target_dir/${base}_${counter}.${ext}"
            fi
            counter=$((counter + 1))
        done
        
        # Copy file
        cp "$file" "$target_file"
        migrated_count=$((migrated_count + 1))
        
        info "Migrated: $file → $target_file"
    done
    
    log "Migration completed: $migrated_count files processed"
}

# =============================================================================
# PHASE 4: CLEANUP OF REDUNDANT DIRECTORIES
# =============================================================================

cleanup_redundant_directories() {
    log "Cleaning up redundant directories..."
    
    # List of directories to clean up (duplicates, scattered docs)
    local cleanup_dirs=(
        "riftcore/docs"
        "riftdoc-000"
        "riftdoc-111"
        "references"
        "docs" # Original scattered docs
    )
    
    for dir in "${cleanup_dirs[@]}"; do
        if [[ -d "$dir" && "$dir" != "docs" ]]; then
            warn "Removing redundant directory: $dir"
            rm -rf "$dir"
        fi
    done
    
    log "Redundant directories cleaned up"
}

# =============================================================================
# PHASE 5: GITBOOK CONFIGURATION
# =============================================================================

create_gitbook_config() {
    log "Creating GitBook configuration..."
    
    # Create book.json
    cat > book.json << 'EOF'
{
    "title": "RIFT Ecosystem Documentation",
    "description": "Comprehensive documentation for the RIFT stage-bound compilation pipeline",
    "author": "OBINexus Computing",
    "language": "en",
    "gitbook": ">=3.0.0",
    "root": "./docs",
    "structure": {
        "readme": "README.md",
        "summary": "SUMMARY.md"
    },
    "plugins": [
        "theme-default",
        "search",
        "sharing",
        "fontsettings",
        "highlight",
        "-lunr",
        "search-pro",
        "github",
        "edit-link",
        "page-toc-button",
        "back-to-top-button"
    ],
    "pluginsConfig": {
        "github": {
            "url": "https://github.com/obinexus/riftdoc"
        },
        "edit-link": {
            "base": "https://github.com/obinexus/riftdoc/edit/main/docs",
            "label": "Edit This Page"
        },
        "sharing": {
            "facebook": false,
            "twitter": true,
            "google": false,
            "weibo": false,
            "all": ["twitter", "github"]
        }
    },
    "variables": {
        "obinexus_session": "'${OBINEXUS_SESSION_ID}'",
        "migration_tag": "'${MIGRATION_TAG}'"
    }
}
EOF

    # Create main README.md
    cat > docs/README.md << 'EOF'
# RIFT Ecosystem Documentation

Welcome to the comprehensive documentation for the RIFT (Recursive Infrastructure for Functional Transformation) ecosystem - a stage-bound compilation pipeline designed for safety-critical, culturally-adaptive programming systems.

## Architecture Overview

The RIFT ecosystem follows a 7-stage compilation pipeline:

1. **Stage 0**: Tokenizer - Lexical analysis and token generation
2. **Stage 1**: Parser - Grammar structuring and syntax validation  
3. **Stage 2**: AST Generator - Abstract syntax tree construction
4. **Stage 3**: Validator - Schema compliance and constraint verification
5. **Stage 4**: Bytecode Generator - Intermediate representation creation
6. **Stage 5**: Verifier - Integrity validation and safety checks
7. **Stage 6**: Emitter - Target code generation with cultural adaptation

## Toolchain Components

- **riftlang.exe** → **shared objects (.so.a)** → **rift.exe** → **gosilang**
- **Build Stack**: nlink → polybuild
- **Compliance**: #NoGhosting + OpenSense recruitment

## OBINexus Session Continuity

This documentation maintains OBINexus session continuity with:
- Structured methodology preservation
- Technical architecture integrity  
- Compliance policy enforcement
- Cultural adaptation support

## Navigation

Use the sidebar to explore different aspects of the RIFT ecosystem. Each section provides detailed technical documentation, examples, and implementation guidance.

---

**Session ID**: {{book.obinexus_session}}  
**Migration Tag**: {{book.migration_tag}}  
**Repository**: [github.com/obinexus/riftdoc](https://github.com/obinexus/riftdoc)
EOF

    # Create SUMMARY.md
    cat > docs/SUMMARY.md << 'EOF'
# Summary

## Introduction
* [Overview](README.md)

## Pipeline Stages
* [Stage 0: Tokenizer](stages/stage-0-tokenizer/README.md)
* [Stage 1: Parser](stages/stage-1-parser/README.md)
* [Stage 2: AST Generator](stages/stage-2-ast/README.md)
* [Stage 3: Validator](stages/stage-3-validator/README.md)
* [Stage 4: Bytecode Generator](stages/stage-4-bytecode/README.md)
* [Stage 5: Verifier](stages/stage-5-verifier/README.md)
* [Stage 6: Emitter](stages/stage-6-emitter/README.md)

## Toolchain
* [RiftLang Compiler](toolchain/riftlang-exe/README.md)
* [Shared Objects](toolchain/shared-objects/README.md)
* [RIFT Runtime](toolchain/rift-exe/README.md)
* [GosiLang Integration](toolchain/gosilang/README.md)

## Build Orchestration
* [NLink Linker](build-orchestration/nlink/README.md)
* [PolyBuild System](build-orchestration/polybuild/README.md)

## Compliance & Governance
* [Legal Policy Framework](compliance/legal-policy/README.md)
* [OpenSense Recruitment](compliance/opensense/README.md)
* [Governance Model](compliance/governance/README.md)

## Technical Specifications
* [LaTeX Specifications](specifications/latex-specs/README.md)
* [Markdown Documentation](specifications/markdown-repos/README.md)
* [Compliance Scripts](specifications/compliance-scripts/README.md)

## Examples & Proofs
* [Proof of Concept](examples/proof-of-concept/README.md)
* [Cultural Adaptation](examples/cultural-adaptation/README.md)
* [Integration Examples](examples/integration/README.md)
EOF

    log "GitBook configuration created"
}

# =============================================================================
# PHASE 6: CREATE INDEX FILES
# =============================================================================

create_index_files() {
    log "Creating index files for all directories..."
    
    # Find all directories in docs/ and create README.md if missing
    find docs -type d | while read -r dir; do
        if [[ ! -f "$dir/README.md" ]]; then
            local dir_name=$(basename "$dir")
            local title=$(echo "$dir_name" | sed 's/-/ /g' | sed 's/\b\w/\u&/g')
            
            cat > "$dir/README.md" << EOF
# $title

## Overview
Documentation and resources for $title in the RIFT ecosystem.

## Contents
$(ls "$dir" 2>/dev/null | grep -v README.md | sed 's/^/- /' || echo "- No additional files")

## OBINexus Session Continuity
- **Session ID**: ${OBINEXUS_SESSION_ID}
- **Migration Tag**: ${MIGRATION_TAG}
- **Toolchain**: riftlang.exe → .so.a → rift.exe → gosilang
- **Build Stack**: nlink → polybuild

---
*Part of the RIFT ecosystem documentation*
EOF
        fi
    done
    
    log "Index files created"
}

# =============================================================================
# PHASE 7: GIT OPERATIONS
# =============================================================================

setup_git_repository() {
    log "Setting up git repository..."
    
    # Initialize git if not already done
    if [[ ! -d .git ]]; then
        git init
        git remote add origin "https://github.com/obinexus/riftdoc.git"
    fi
    
    # Create/update .gitignore
    cat > .gitignore << 'EOF'
# Backup directories
backup_*/

# Log files
*.log

# OS files
.DS_Store
Thumbs.db
desktop.ini

# IDE files
.vscode/
.idea/
*.swp
*.swo

# GitBook build artifacts
_book/
node_modules/

# Temporary files
*.tmp
*.temp

# OBINexus session files (internal use only)
*.obinexus
*.phenomenohog
EOF
    
    # Stage all changes
    git add .
    
    # Create commit
    git commit -m "docs: RIFT documentation cleanup and reorganization

- Implemented stage-bound architecture (Stages 0-6)
- Migrated scattered documentation to organized structure  
- Created GitBook configuration for comprehensive documentation
- Maintained OBINexus session continuity
- Preserved toolchain identifiers: riftlang.exe → .so.a → rift.exe → gosilang
- Maintained build stack: nlink → polybuild
- Enforced compliance: #NoGhosting + OpenSense

Migration Tag: ${MIGRATION_TAG}
Session ID: ${OBINEXUS_SESSION_ID}

Fixes: Repository organization and documentation accessibility
Resolves: Scattered documentation and inconsistent structure"
    
    log "Git repository configured with migration commit"
}

# =============================================================================
# MAIN EXECUTION FUNCTION
# =============================================================================

main() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}  RIFT DOCUMENTATION CLEANUP & REORG   ${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""
    echo "Repository: github.com/obinexus/riftdoc"
    echo "Session ID: ${OBINEXUS_SESSION_ID}"
    echo "Migration Tag: ${MIGRATION_TAG}"
    echo ""
    
    # Check if we're in the right repository
    if [[ ! -f "README.md" ]] || ! grep -q "RIFT" README.md 2>/dev/null; then
        warn "This doesn't appear to be the RIFT documentation repository"
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
    
    # Execute cleanup phases
    log "=== PHASE 1: BACKUP AND PREPARATION ==="
    create_backup
    
    log "=== PHASE 2: STAGE-BOUND STRUCTURE CREATION ==="
    create_stage_bound_structure
    
    log "=== PHASE 3: FILE MIGRATION ==="
    migrate_files
    
    log "=== PHASE 4: CLEANUP REDUNDANT DIRECTORIES ==="
    cleanup_redundant_directories
    
    log "=== PHASE 5: GITBOOK CONFIGURATION ==="
    create_gitbook_config
    
    log "=== PHASE 6: INDEX FILE CREATION ==="
    create_index_files
    
    log "=== PHASE 7: GIT REPOSITORY SETUP ==="
    setup_git_repository
    
    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}    CLEANUP & REORGANIZATION COMPLETE  ${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
    echo "📁 Backup created at: $BACKUP_DIR"
    echo "📝 Log file: $LOG_FILE"
    echo "🏗️  Documentation structure: docs/"
    echo "📚 GitBook config: book.json"
    echo ""
    echo "Next steps:"
    echo "1. Review the new structure in docs/"
    echo "2. Test GitBook build: gitbook serve"
    echo "3. Push to GitHub: git push origin main"
    echo "4. Configure GitBook integration"
    echo ""
    echo "OBINexus Session Continuity: MAINTAINED ✅"
    echo "Stage-bound Architecture: IMPLEMENTED ✅"
    echo "Toolchain Integrity: PRESERVED ✅"
}

# Execute main function
main "$@"
