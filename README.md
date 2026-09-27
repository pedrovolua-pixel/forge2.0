# Forge 2.0

This repository is currently bootstrapped with an engineering operating system only. Product discovery has not started, no application architecture or technology stack has been selected, and no application should be implemented from the current contents.

[`AGENTS.md`](./AGENTS.md) is the governing entry point for contributors and AI-assisted workflows. Repository documentation is authoritative over prior chat context.

## Current phase

**Engineering OS bootstrap validated; stopped before product discovery.**

The current repository provides:

- control rules and approval boundaries;
- locations for product, specification, architecture, development, operations, security, and planning records;
- templates for product specifications, technical specifications, implementation plans, test plans, feature status, ADRs, and release-readiness reviews;
- repeatable workflows for specification, planning, implementation, review, verification, security review, and release review; and
- a local structural validator for the engineering OS.

The absence of product requirements, an application stack, application code, environment configuration, deployment procedures, and production infrastructure is intentional at this phase.

## Lifecycle

Substantial product behavior follows this sequence:

1. Product discovery records explicit owner input under [`product`](./product/) and in a feature product specification.
2. A human product owner approves product scope.
3. Technical design traces the approved requirements and proposes ADRs for consequential architectural decisions.
4. An authorized human reviewer approves the technical design and applicable ADRs.
5. An implementation plan and test plan make the work and evidence traceable.
6. Implementation, independent review, and verification proceed against the approved artifacts.
7. Release readiness is assessed from recorded evidence; production approval remains human-controlled.

Do not skip gates by treating templates, assumptions, chat messages, or draft documents as approvals.

## Validate the bootstrap

From the repository root, run:

```sh
./scripts/validate-engineering-os.sh
```

The validator checks the required operating-system files, template control language, skill metadata, and governing local reference targets. It does not validate external repository settings such as branch protection or CI enforcement.

The initial validation result and remaining bootstrap limitations are recorded in [`docs/development/engineering-os-bootstrap.md`](./docs/development/engineering-os-bootstrap.md).
