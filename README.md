Soma
====

Lau emulation of Elixir semantics

Status
======

Presently working on building out rudimentary framework for 
immutable Soma types, using integers as the test case. 
See [TODO](TODO) for current task list.

Docs can be found at https://beadsland.github.io/Soma/.

Story So Far
============

There are a number of applications that I am looking forward to developing. Let's call these Jack 1, Jack 2...Jack *n*, or *All the Jacks*, for short.

All the Jacks will share a common programming paradigm, let's call this paradigm *Malt*, in lieu of a better name. As of now Malt does not yet exist. We need Malt to build All the Jacks.

As it happens, Elixir appears to be the most intuitive language for developing Malt. However, All the Jacks are meant to run, in part, as clients on mobile devices. Only, Elixir apps (*i.e.*, BEAM, *a/k/a* Erlang VM apps) don't readily deploy to major mobile platforms.

So while development of server-side application components will be done in Elixir, I want a ready way to reproduce Malt functionality client-side without reinventing Malt from the ground up.

As it happens, tools do exist to deploy applications developed in Lua across various mobile platforms. Furthermore, Lua is extensible and, while its asymettric coroutines are hardly lightweight processes, the former can conceivably be used to mimic the latter.

And so, in order to have a mobile-friendly, Elixir-similar setting, to germinate the cross-platform Malt, to feed All the Jacks, we need a rat... or, ehm, rather we need Soma, an emulation of the semantics (if not the syntax) of Elixir, written in Lua.

And so here we are. Okay, enough nattering. Time I got to writing this thing.

Naming Things
=============

Soma is a multiple entendre. Soma was a Vedic ritual drink, said to produce immortality, much like the mythical elixir of alchemists. In post-Vedic Hindu mythology, Soma is deity of the Moon, *i.e.*, that which the Portuguese call Lua.

Meanwhile, soma is the part of a neuron that contains the nucleus, just as this project comprises the core of various future programming projects. Finally, *soma* comes to English from the Greek word for "body". In that respect the meta-project that is Soma, Malt and All the Jacks *relates* to texts by Annemarie Mol, which serve as major inspiration of the longer term vision motivating this work.

License
=======

"Soma" is copyright © 2017 Beads Land-Trujillo.

Soma source code is released under Apache 2.0 License.

Check [NOTICE](NOTICE) and [LICENSE](LICENSE) files for more information.
