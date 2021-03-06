# SubtitleIt
# SRT - Subrip format
#
# N
# 00:55:21,600 --> 00:55:27,197
# lt's not even 20 years. You've sold the
# casinos and made fortunes for all of us.
#
# Where N is the sub index number
#
module Formats
  include PlatformEndLine

  def endl
    endline(@raw)
  end

  def parse_srt
    @raw.split(endl * 2).inject([]) do |final, line|
      line = line.split(endl)
      line.delete_at(0)
      time_on, time_off = line[0].split('-->').map(&:strip)
      line.delete_at(0)
      text = line.join('|')
      final << Subline.new(time_on, time_off, text)
    end
  end

  def to_srt
    out = []
    @lines.each_with_index do |l, i|
      out << "#{i + 1}"
      out << '%s --> %s' % [l.time_on.to_s(','), l.time_off.to_s(',')]
      out << (l.text ? l.text.gsub('|', endl) : ' ') + endl
    end
    out.join(endl)
  end
end

# looks like subrip accepts some styling:
#     sdict.add(new StyledFormat(ITALIC, "i", true));
#     sdict.add(new StyledFormat(ITALIC, "/i", false));
#     sdict.add(new StyledFormat(BOLD, "b", true));
#     sdict.add(new StyledFormat(BOLD, "/b", false));
#     sdict.add(new StyledFormat(UNDERLINE, "u", true));
#     sdict.add(new StyledFormat(UNDERLINE, "/u", false));
#     sdict.add(new StyledFormat(STRIKETHROUGH, "s", true));
#     sdict.add(new StyledFormat(STRIKETHROUGH, "/s", false));
