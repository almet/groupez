module Views.Utils exposing (formatDate)

import Time
import Time.Format
import Time.Format.Config.Config_fr_fr exposing (config)


formatDate : Time.Posix -> String
formatDate date =
    Time.Format.format config "%-d %B %Y" Time.utc date
