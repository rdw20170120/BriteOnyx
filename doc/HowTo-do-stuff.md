# HowTo do stuff

This document captures how to do various "stuff"
that I eventually want to move somewhere else.
For most "stuff",
I want to automate it in one or more scripts.
For some stuff,
I want to create an appropriate document
focused on that particular kind of "stuff".

## Publish a release

When it is time to publish a new release,
here are my steps.

1. First, finish all the changes
1. Commit those changes
1. `git tag -a X.Y.Z -m "Release X.Y.Z"`
1. `git push origin --follow-tags`

However,
since I want annotated tags to be pushed
by default for all my project repositories,
I have configured Git globally with
`push.followTags=true`.

Nonetheless,
I cannot count on that global Git configuration,
so I will add the appropriate command
to this project's `lib/project_override.bash` script.
