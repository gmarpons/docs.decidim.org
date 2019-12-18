let Map = https://prelude.dhall-lang.org/Map/Type

in  { site :
        { title : Text
        , url : Text
        , start_page : Optional Text
        , keys : Optional (Map Text Text)
        }
    , content :
        { branches : Optional (List Text)
        , sources :
            List
              { url : Text
              , branches : Optional (List Text)
              , tags : Optional (List Text)
              , start_path : Optional Text
              }
        }
    , asciidoc :
        Optional
          { attributes : Optional (Map Text Text)
          , extensions : Optional (List Text)
          }
    , ui :
        { bundle :
            { url : Text, snapshot : Optional Bool, start_path : Optional Text }
        , default_layout : Optional Text
        , output_dir : Optional Text
        , supplemental_files : Optional Text
        }
    , output :
        Optional
          { clean : Optional Bool
          , dir : Optional Text
          , destinations : List { provider : Text }
          }
    , runtime : Optional { cache_dir : Optional Text, fetch : Optional Bool }
    }
