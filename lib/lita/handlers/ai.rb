module Lita
  module Handlers
    class Ai < Handler
      on :unhandled_message, :chat

      def self.cleverbot
        @cleverbot ||= Cleverbot::Client.new
      end

      def chat(payload)
        return unless chatting?(payload[:message])
        message = extract_aliases(payload[:message])
        response.reply cleverbot.write message
      end

      private

      def chatting?(message)
        message.command? || message.body =~ /#{aliases.join('|')}/i
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
