# Design

I have recently encountered some complications
with shell inheritance
and other nuances.
I am researching the best way forward.

This is a collection
of relevant thoughts
and design choices.

I have been doing most of my recent work
on Apple macOS in Ghostty.
However,
I love Linux
and have often done
all my development and deployment work there.
I am returning to that practice
but I first need
my macOS environment
as a stable foundation
under those efforts.

On macOS,
I intentionally leave ZSH as my default shell.
I only stay in ZSH long enough to invoke Bash.
Having ZSH as `SHLVL`=1
means that my terminal (usually) does not close
when I inevitably encounter a Bash error exit.
When BriteOnyx is robust enough,
I intend to change my default shell to Bash.

On the other hand,
I have been watching the
[Oils for Unix](https://github.com/oils-for-unix/oils)
project,
and I am very hopeful about
replacing Bash
with OSH
and eventually YSH.
I have dabbled with them both
but I first want
to build and maintain BriteOnyx
running on Bash.
When that is stable and feature-complete,
I will reimplement BriteOnyx
in OSH and then YSH.
I intend to keep the Bash implementation for
the vast majority of people
who resist moving past Bash
and for
the situations where constraints may force Bash.

I am researching other Bash scripting frameworks/libraries.

I want to build
even-more-robust
and easy-to-use
error handling
into BriteOnyx.
I see some promising
lessons and ideas
for me
in other people's work.
I intend to shamelessly
borrow and build upon
their work,
all with proper attribution.

I have realized that I overuse environment exporting.
I am pulling back from this,
to an extreme--for the moment.
I am stripping out all `export`s.
I will then `export`
only what I must.
I intend to build tests
to prove to myself
that an `export` is actually required.

I must be careful about signals, traps, and inheritance.
I will redesign, reimplement, and/or borrow
an error, signal, trap approach.

Shell options are challenging.
Most important is leaving the user
with a "habitable" shell.
Scripts that execute as commands
have their own process,
so they can be much stricter
about their environment
and how they exit it.
Shell startup configuration scripts
must be invoked via `source`
and therefore can directly affect
the user's interactive shell.

Therefore,
I must ensure that BriteOnyx
leaves the `errexit` and `nounset` options disabled
in the final interactive user's shell session.
However,
`nounset` seems helpful
most of the time,
just not at the actual command line.

It seems that `pipefail` is always helpful.

I see that some others
avoid using `errexit`,
as I have for most of my career.
I am returning to that,
so I am stripping out `errexit` for now.
I am hoping for an approach
that makes invoking `errexit` unnecessary.

I am testing across all four combinations
of (non)interactive and non(login) shell sessions.
I do not anticipate a need
to explicitly support other possibilities
such as restricted shell sessions.

BriteOnyx will honor the
[`NO_COLOR`](https://no-color.org)
conventions.
Color is one of its design features,
so BriteOnyx will use color by default though.
Similarly, BriteOnyx will honor a similar
`NO_TIME` convention.
I could find nothing established yet,
but it has become obvious to me
that it is sometimes useful
to turn off (almost) all timestamps
just as it is sometimes useful
to turn off all color.
This is primarily targeted at logging output.
I find that
both color and timestamps
tend to really complicate
testing as they clutter (and vary) execution output.
BriteOnyx will also honor a `boNO` convention
to disable itself completely,
for similar reasons.
