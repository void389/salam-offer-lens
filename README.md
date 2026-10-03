# Salam Offer Lens

Salam Offer Lens is an offline command-line auditor for public work and bounty
offers, built with the [Salam Programming Language](https://github.com/SalamLang/Salam).
It turns a compact offer record into a repeatable evidence report. The report
separates stated facts from missing terms, blocks offers that require upfront
spend, and recommends one read-only verification step.

## Why this exists

Public paid-work listings often mix concrete terms with assumptions. Offer Lens
does not claim that a sponsor is trustworthy or that payment is guaranteed. It
checks whether five practical facts are present:

- a positive numeric reward and named currency;
- a stated deadline;
- an explicit funding statement;
- no required payment, stake, gas, or deposit;
- an HTTPS submission route.

Each fact has an independent Salam module. The final score is therefore easy to
explain and change without hiding policy in one large function.

## Input format

An `.offer` file contains one pipe-delimited row:

```text
TITLE|REWARD|CURRENCY|DEADLINE|REQUIRES_SPEND|FUNDED|SUBMISSION_URL
```

Example:

```text
Public API schema check|25|USDC|2026-10-31|no|yes|https://example.test/submit
```

Values are copied from a primary listing. `REQUIRES_SPEND` and `FUNDED` accept
`yes`/`no`, `true`/`false`, and a few plain-language equivalents.

## Build and run

Install Salam 0.4.7 or newer from the official project, then run:

```powershell
salam build salam.salam --backend=c --output=build/offer-lens.exe
./build/offer-lens.exe samples/ready.offer
```

Expected summary:

```text
Offer: Public API schema check
Verdict: READY
Evidence score: 100/100
```

The process exits with `0` for `READY`, `2` for `REVIEW`, `3` for `BLOCKED`,
and `64` for invalid input. This makes the tool suitable for local scripts while
keeping its human-readable report.

## Test

Set `SALAM` to the compiler path when it is not on `PATH`, then run:

```powershell
./scripts/test.ps1
```

The Salam test executable covers complete, risky, malformed, and non-numeric
records as well as the documented exit-code contract.

## Architecture

The entry point reads a file and delegates to small focused packages:

- `parser` and `offertext` normalize the seven factual fields;
- `reward`, `deadline`, `funding`, `spend`, and `submission` evaluate evidence;
- `score` derives the score and verdict;
- `nextcheck` chooses the highest-priority unresolved check;
- `audit` coordinates the rules;
- `report` renders stable output;
- `exitcode` exposes a shell-friendly result.

## Limits

Offer Lens is a triage aid. It does not contact sponsors, inspect wallets,
predict acceptance, or prove that payment will occur. A `READY` result means the
record contains the expected evidence and no stated upfront-spend requirement.

## Development note

This project was developed with AI assistance, as permitted by the originating
Salam project bounty. The source was compiled with Salam 0.4.7 and its rule
suite was executed locally before publication.

## License

MIT
