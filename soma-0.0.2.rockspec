package = "Soma"
version = "0.0.1"
source = {
   url = "git://github.com/beadsland/soma",
   tag = "v0.0.1"
}
description = {
   summary = "Lau emulation of Elixir semantics",
   detailed = "Lau emulation of Elixir semantics",
   homepage = "https://beadsland.github.io/Soma/",
   license = "Apache 2.0"
}
dependencies = {
  "lua = 5.1",
  "lbc >= 20120430-1"
}
build = {
   type = "builtin",
   modules = {
      soma = "src/init.lua",
      ['soma.term'] = "src/term.lua",
      ['soma.type'] = "src/type/init.lua",
      ['soma.type.integer'] = "src/type/integer.lua",
      ['soma.util'] = "src/util/init.lua",
      ['soma.util.isnan'] = "src/util/isnan.lua"
   },
   copy_directories = {
      "docs"
   }
}
