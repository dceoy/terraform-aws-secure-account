# Repository Guidelines

## Project Structure & Module Organization

- `modules/` houses reusable Terraform modules (e.g., `iam`, `kms`, `s3`, `guardduty`, `securityhub`). Each module is self-contained with its own `.tf` files.
- `envs/plt/` is the primary environment (“platform”) that wires modules together via `main.tf`, with inputs in `variables.tf` and outputs in `outputs.tf`.
- `cloudformation/` contains bootstrap CloudFormation templates (for example, `s3-for-terraform.cfn.yml`).
- `.github/workflows/ci.yml` defines the CI lint/scan workflows.

## Build, Test, and Development Commands

Run Terraform from the `envs/plt/` directory (examples below use `-chdir`):

```sh
# Create S3 backend resources
aws cloudformation create-stack \
  --stack-name s3-for-terraform \
  --template-body file://cloudformation/s3-for-terraform.cfn.yml

# Initialize config files
cp envs/plt/example.tfbackend envs/plt/aws.tfbackend
cp envs/plt/example.tfvars envs/plt/terraform.tfvars

# Initialize, plan, apply, destroy
terraform -chdir='envs/plt/' init -upgrade -reconfigure -backend-config='./aws.tfbackend'
terraform -chdir='envs/plt/' plan -var-file='./terraform.tfvars'
terraform -chdir='envs/plt/' apply -var-file='./terraform.tfvars' -auto-approve
terraform -chdir='envs/plt/' destroy -var-file='./terraform.tfvars' -auto-approve
```

## Coding Style & Naming Conventions

- Use standard Terraform formatting (`terraform fmt`). Existing code uses aligned assignments and consistent block spacing.
- YAML files use 2-space indentation (see `cloudformation/*.yml`).
- Module and variable names follow `snake_case` and lowercase directory names (e.g., `modules/securityhub`).

## Testing Guidelines

- There is no dedicated unit test suite. Validation is primarily handled by CI.
- CI runs CloudFormation linting and Terraform lint/scan workflows via GitHub Actions.
- For local checks, rely on `terraform plan` in `envs/plt/` before opening a PR.

## Commit & Pull Request Guidelines

- Commit messages are short, imperative, sentence-case.
- Branch names use appropriate prefixes on creation (e.g., `feature/short-description`, `bugfix/short-description`).
- PRs should include: a clear summary, relevant context or linked issue.
- When instructed to create a PR, create it as a draft with appropriate labels by default.

## Security & Configuration Tips

- Copy and edit `envs/plt/example.tfbackend` and `envs/plt/example.tfvars` rather than modifying the examples directly.
- Keep secrets out of the repo; use local AWS credentials (`~/.aws/config` and `~/.aws/credentials`).
- Ensure the S3 backend stack is created before running `terraform init`.

## Code Design Principles

Follow Robert C. Martin's SOLID and Clean Code principles:

### SOLID Principles

1. **SRP (Single Responsibility)**: One reason to change per class; separate concerns (e.g., storage vs formatting vs calculation)
2. **OCP (Open/Closed)**: Open for extension, closed for modification; use polymorphism over if/else chains
3. **LSP (Liskov Substitution)**: Subtypes must be substitutable for base types without breaking expectations
4. **ISP (Interface Segregation)**: Many specific interfaces over one general; no forced unused dependencies
5. **DIP (Dependency Inversion)**: Depend on abstractions, not concretions; inject dependencies

### Clean Code Practices

- **Naming**: Intention-revealing, pronounceable, searchable names (`daysSinceLastUpdate` not `d`)
- **Functions**: Small, single-task, verb names, 0-3 args, extract complex logic
- **Classes**: Follow SRP, high cohesion, descriptive names
- **Error Handling**: Exceptions over error codes, no null returns, provide context, try-catch-finally first
- **Testing**: TDD, one assertion/test, FIRST principles (Fast, Independent, Repeatable, Self-validating, Timely), Arrange-Act-Assert pattern
- **Code Organization**: Variables near usage, instance vars at top, public then private functions, conceptual affinity
- **Comments**: Self-documenting code preferred, explain "why" not "what", delete commented code
- **Formatting**: Consistent, vertical separation, 88-char limit, team rules override preferences
- **General**: DRY, KISS, YAGNI, Boy Scout Rule, fail fast

## Development Methodology

Follow Martin Fowler's Refactoring, Kent Beck's Tidy Code, and t_wada's TDD principles:

### Core Philosophy

- **Small, safe changes**: Tiny, reversible, testable modifications
- **Separate concerns**: Never mix features with refactoring
- **Test-driven**: Tests provide safety and drive design
- **Economic**: Only refactor when it aids immediate work

### TDD Cycle

1. **Red** → Write failing test
2. **Green** → Minimum code to pass
3. **Refactor** → Clean without changing behavior
4. **Commit** → Separate commits for features vs refactoring

### Practices

- **Before**: Create TODOs, ensure coverage, identify code smells
- **During**: Test-first, small steps, frequent tests, two hats rule
- **Refactoring**: Extract function/variable, rename, guard clauses, remove dead code, normalize symmetries
- **TDD Strategies**: Fake it, obvious implementation, triangulation

### When to Apply

- Rule of Three (3rd duplication)
- Preparatory (before features)
- Comprehension (as understanding grows)
- Opportunistic (daily improvements)

### Key Rules

- One assertion per test
- Separate refactoring commits
- Delete redundant tests
- Human-readable code first

> "Make the change easy, then make the easy change." - Kent Beck
