module Lita
  module Handlers
    class Ai < Handler
      on :unhandled_message, :chat

      def self.cleverbot
        @cleverbot ||= CleverBot.new
      end

      def chat(payload)
        message = payload[:message]
        return unless should_reply?(message)
        robot.send_message(message.source, build_response(message))
      end

      private

      def should_reply?(message)
        message.command? || message.body =~ /#{aliases.join('|')}/i
      end

      def build_response(message)
        message = extract_aliases(message)
        reply = self.class.cleverbot.think(message.body)
        reply.to_s.gsub(/\|([0-9A-F]{4})/) { ["#{$1}".hex].pack("U") } if reply
      end

      def extract_aliases(message)
        body = message.body.sub(/#{aliases.join('|')}/i, '').strip
        Message.new(robot, body, message.source)
      end

      def aliases
        [robot.mention_name, robot.alias].map{|a| a unless a == ''}.compact
      end

      Lita.register_handler(self)
    end
  end
end
