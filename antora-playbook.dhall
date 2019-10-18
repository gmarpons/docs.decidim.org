let Prelude = https://prelude.dhall-lang.org/package.dhall

let Map = https://prelude.dhall-lang.org/Map/Type

let Playbook = ./antora-playbook-schema.dhall

let reposDir = Some env:REPOS_DIR as Text ? None Text

let Branch = < Master | Other : Text >

let site =
      { title = "Decidim Docs"
      , url = "https://docs.decidim.org"
      , start_page = Some "en@init::index.adoc"
      , keys = None (Map Text Text)
      }

let branchesDefault = None (List Text)

let languageDefault =
      { branches = Some [ Branch.Master ], tags = None (List Text) }

let sources
    : List
        { name : Text
        , languages :
            List
              { name : Text
              , branches : Optional (List Branch)
              , tags : Optional (List Text)
              }
        }
    = [ { name = "docs.decidim.org"
        , languages =
            [ languageDefault // { name = "landing-page/ca" }
            , languageDefault // { name = "landing-page/en" }
            , languageDefault // { name = "landing-page/es" }
            ]
        }
      , { name = "docs-admin-manual"
        , languages =
            [ languageDefault // { name = "ca" }
            , languageDefault // { name = "en" }
            , languageDefault // { name = "es" }
            ]
        }
      , { name = "docs-authoring-guide"
        , languages = [ languageDefault // { name = "en" } ]
        }
      , { name = "docs-config-tutorial"
        , languages = [ languageDefault // { name = "es" } ]
        }
      , { name = "docs-deploy-and-admin"
        , languages =
            [ languageDefault // { name = "ca" }
            , languageDefault // { name = "en" }
            , languageDefault // { name = "es" }
            ]
        }
      , { name = "docs-developers-manual"
        , languages = [ languageDefault // { name = "en" } ]
        }
      , { name = "docs-features"
        , languages =
            [ languageDefault // { name = "ca" }
            , languageDefault // { name = "en" }
            , languageDefault // { name = "es" }
            ]
        }
      , { name = "docs-social-contract"
        , languages =
            [ languageDefault // { name = "ca" }
            , languageDefault // { name = "en" }
            , languageDefault // { name = "es" }
            ]
        }
      , { name = "docs-whitepaper"
        , languages = [ languageDefault // { name = "en" } ]
        }
      ]

let ui =
      { bundle =
          { snapshot =
              Some True
          , start_path = None Text
          , url =
              "https://github.com/decidim/docs.decidim.org-ui/releases/download/v3/ui-bundle.zip"
          }
      , default_layout = None Text
      , output_dir = None Text
      }

let asciidoc =
      Some
      { attributes =
          Some
          [ { mapKey = "idseparator", mapValue = "-" }
          , { mapKey = "xrefstyle", mapValue = "short" }
          , { mapKey = "idprefix", mapValue = "" }
          ]
      , extensions = None (List Text)
      }

let output =
      None
        { clean : Optional Bool
        , destinations : List { provider : Text }
        , dir : Optional Text
        }

let runtime = Some { cache_dir = Some "./.cache/antora", fetch = None Bool }

let content =
      let Language =
            { name : Text
            , branches : Optional (List Branch)
            , tags : Optional (List Text)
            }
      
      let SourceIn : Type = { languages : List Language, name : Text }
      
      let SourceOut
          : Type
          = { branches : Optional (List Text)
            , start_path : Optional Text
            , tags : Optional (List Text)
            , url : Text
            }
      
      let mkUrl
          : Text -> Text
          =     \(name : Text)
            ->  Optional/fold
                  Text
                  reposDir
                  Text
                  (\(dir : Text) -> "${dir}/${name}.git")
                  "https://github.com/decidim/${name}.git"
      
      let branch2text =
                \(branch : Branch)
            ->  merge
                  { Master =
                      Optional/fold
                        Text
                        reposDir
                        Text
                        (\(_ : Text) -> "HEAD")
                        "master"
                  , Other = \(t : Text) -> t
                  }
                  branch
      
      let addSource =
                \(sourceName : Text)
            ->  \(language : Language)
            ->  \(list : List SourceOut)
            ->    list
                # [ { url = mkUrl sourceName
                    , start_path = Some language.name
                    , branches =
                        Optional/fold
                          (List Branch)
                          language.branches
                          (Optional (List Text))
                          (     \(l : List Branch)
                            ->  Some
                                (Prelude.List.map Branch Text branch2text l)
                          )
                          (None (List Text))
                    , tags = language.tags
                    }
                  ]
      
      let func
          : SourceIn -> List SourceOut
          =     \(s : SourceIn)
            ->  List/fold
                  Language
                  s.languages
                  (List SourceOut)
                  (addSource s.name)
                  ([] : List SourceOut)
      
      in      { branches = branchesDefault }
          //  { sources =
                  Prelude.List.concat
                    SourceOut
                    (Prelude.List.map SourceIn (List SourceOut) func sources)
              }

in    { site = site
      , content = content
      , ui = ui
      , asciidoc = asciidoc
      , runtime = runtime
      , output = output
      }
    : Playbook
