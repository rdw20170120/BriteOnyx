# BriteOnyx

Open-source scripting framework
supporting shell customization
and robust DevOps workflows

I have spent an entire multi-decade career
building and rebuilding development environments
for myself and my teams,
literally hundreds of them.
I have captured and refined my techniques
into this project repository,
and now
I am releasing it into the world
so that I can leverage it
across my machines and projects
as well as with the hope
that others might find it useful.

I will be fully documenting
the lessons, goals, techniques, and implementation
that makes BriteOnyx into my essential tool
for bootstrapping ALL my
user accounts,
development environments,
and production deployments.

BriteOnyx is very volatile at the moment
as it is under heavy development.
Nonetheless,
it is already quite usable
and already serves as the foundation
of all my user accounts
and development efforts.

To use BriteOnyx (for now):

- navigate your web browser to [the project home page](https://github.com/rdw20170120/BriteOnyx)
- download the
  [install-source.bash](https://github.com/rdw20170120/BriteOnyx/blob/main/install-source.bash)
  script to some local `DIRECTORY`
- read that script, understand it, OR do NOT ever trust it
- [pick a TAG](https://github.com/rdw20170120/BriteOnyx/tags)
- IF you trust it, use the script to install the BriteOnyx framework:

```bash
bash
source DIRECTORY/install-source.bash \
    BriteOnyx TAG \
    https://github.com/rdw20170120/BriteOnyx.git
```

That will let you review the framework, somewhat, for now.
The next steps are to be able to experiment with the framework
within its own project repository
and eventually
from within YOUR own project repository.
I still have some work to do for that
since I am redesigning the startup process.

I have been using BriteOnyx from
[my Bash profile](https://codeberg.org/rdw6688/dotfile/src/branch/main/.bashrc),
and I have begun to rehook the framework
based on my redesign efforts.
You can see this for yourself in
[my dotfiles project](https://codeberg.org/rdw6688/dotfile).

I still need to (re)hook the redesigned framework
into my `source_me.bash` scripts
across all my project repositories.
That should happen over the next few weeks.
Since this is the project repository
for BriteOnyx itself,
it is a special case.

I encountered some complications
with shell inheritance
and other nuances.
I am doing a lot of research and redesign
regarding the best way forward.

For now,
I am stripping down my dotfiles
and BriteOnyx
to a bare minimum.
I am then building it back up
with even-more-robust
design choices
and testing.
