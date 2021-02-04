# Import all plugins from `rel/plugins`
# They can then be used by adding `plugin MyPlugin` to
# either an environment, or release definition, where
# `MyPlugin` is the name of the plugin module.
~w(rel plugins *.exs)
|> Path.join()
|> Path.wildcard()
|> Enum.map(&Code.eval_file(&1))

use Distillery.Releases.Config,
    default_release: :default,
    default_environment: Mix.env()

environment :dev do
  set dev_mode: true
  set include_erts: false
  set cookie: :";Wgc0XFOj~RUZf`InX2%=KZ$({.q3)6GLf.}=_2w7{Ai!nPol$Wbq0QVs5U8qZj1"
end
environment :vagrant do
  set include_erts: true
  set include_src: false
  set cookie: :"d5e6d34e1daad4f129f2aa53ef22a5042d62da90fc226f127fd6d0565e66b045"
  set vm_args: "rel/vm.args"
end
environment :prod do
  set include_erts: true
  set include_src: false
  set cookie: :"hK2]Uc(~WYJEWAj3/zE8cG0l./B7?db/5g@DYA8KITXLIIgO`C8O=c}>U]]c)H]c"
  set vm_args: "rel/vm.args"
end

release :whereami do
  set version: current_version(:whereami)
  set applications: [:runtime_tools]
end
