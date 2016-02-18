module Serializers
  class Question < SimpleDelegator
    def as_json
      if freeform?
        ch_out = tallies.map do |t|
          {
            value: t.value,
            count: t.count
          }
        end
      else
        ch_out = choices.map do |ch|
          Serializers::Choice.new(ch).as_json
        end
      end

      # FIXME
      if exclusive_combo?
        ch_out << Serializers::Choice.new(::Choice.combination(self)).as_json
      end

      {
        key: key,
        text: text,
        type: question_type,
        choices: ch_out
      }
    end
  end
end