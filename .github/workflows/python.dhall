let GithubActions =
      https://raw.githubusercontent.com/regadas/github-actions-dhall/master/package.dhall sha256:8efe6772e27f99ed3a9201b4e45c68eeaaf82c349e70d36fbe89185a324f6519

let matrix = toMap { pyver = [ "36", "38" ] }

in  GithubActions.Workflow::{
    , name = "Greeting"
    , on = GithubActions.On::{
      , push = Some GithubActions.Push::{=}
      , pull_request = Some GithubActions.PullRequest::{=}
      }
    , jobs = toMap
        { setup = GithubActions.Job::{
          , runs-on = GithubActions.RunsOn.Type.ubuntu-latest
          , steps = [ GithubActions.steps.checkout ]
          }
        , build = GithubActions.Job::{
          , needs = Some [ "setup" ]
          , runs-on = GithubActions.types.RunsOn.ubuntu-latest
          , strategy = Some GithubActions.Strategy::{ matrix = matrix }
          , steps =
            [ GithubActions.steps.run { run = "tox -e py\${{ matrix.pyver }}" }
            ]
          }
        }
    }
