require "lita"
require "clever-api"
require "htmlentities"

Lita.load_locales Dir[File.expand_path(
  File.join("..", "..", "locales", "*.yml"), __FILE__
)]

require "lita/handlers/ai"

Lita::Handlers::Ai.template_root File.expand_path(
  File.join("..", "..", "templates"),
 __FILE__
)
