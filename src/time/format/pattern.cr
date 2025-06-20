struct Time::Format
  # :nodoc:
  module Pattern
    def visit(pattern)
      reader = Char::Reader.new(pattern)
      while reader.has_next?
        char = reader.current_char
        reader = check_char reader, char
        reader.next_char
      end
    end

    private def check_char(reader, char)
      case char
      when '%'
        case char = reader.next_char
        when 'a'
          short_day_name
        when 'A'
          day_name
        when 'b', 'h'
          short_month_name
        when 'c'
          date_and_time
        when 'B'
          month_name
        when 'C'
          year_divided_by_100
        when 'd'
          day_of_month_zero_padded
        when 'D', 'x'
          date
        when 'e'
          day_of_month_blank_padded
        when 'F'
          year_month_day
        when 'g'
          calendar_week_year_modulo100
        when 'G'
          calendar_week_year
        when 'H'
          hour_24_zero_padded
        when 'I'
          hour_12_zero_padded
        when 'j'
          day_of_year_zero_padded
        when 'k'
          hour_24_blank_padded
        when 'l'
          hour_12_blank_padded
        when 'L'
          milliseconds
        when 'm'
          month_zero_padded
        when 'M'
          minute
        when 'n'
          char '\n'
        when 'N'
          second_fraction
        when 'p'
          am_pm
        when 'P'
          am_pm_upcase
        when 'r'
          twelve_hour_time
        when 'R'
          twenty_four_hour_time
        when 's'
          unix_seconds
        when 'S'
          second
        when 't'
          char '\t'
        when 'T', 'X'
          twenty_four_hour_time_with_seconds
        when 'u'
          day_of_week_monday_1_7
        when 'V'
          calendar_week_week
        when 'w'
          day_of_week_sunday_0_6
        when 'y'
          year_modulo_100
        when 'Y'
          year
        when 'z'
          time_zone
        when 'Z'
          time_zone_name
        when '_'
          case char = reader.next_char
          when 'm'
            month_blank_padded
          else
            char '%'
            char '_'
            reader = check_char reader, char
          end
        when '-'
          case char = reader.next_char
          when 'd'
            day_of_month
          when 'm'
            month
          else
            char '%'
            char '-'
            reader = check_char reader, char
          end
        when '^'
          case char = reader.next_char
          when 'a'
            short_day_name_upcase
          when 'A'
            day_name_upcase
          when 'b', 'h'
            short_month_name_upcase
          when 'B'
            month_name_upcase
          when 'Z'
            time_zone_name(zone: true)
          else
            char '%'
            char '^'
            reader = check_char reader, char
          end
        when ':'
          case char = reader.next_char
          when 'z'
            time_zone_colon
          when ':'
            case char = reader.next_char
            when 'z'
              time_zone_colon_with_seconds
            else
              char '%'
              char ':'
              char ':'
              reader = check_char reader, char
            end
          else
            char '%'
            char ':'
            reader = check_char reader, char
          end
        when '3', '6', '9'
          digit_char = char
          case char = reader.next_char
          when 'N'
            case digit_char
            when '3'
              milliseconds
            when '6'
              microseconds
            when '9'
              nanoseconds
            else
              raise "Bug: someone forgot to match some numbers"
            end
          else
            char '%'
            char digit_char
            reader = check_char reader, char
          end
        when '%'
          char '%'
        else
          char '%'
          char char
        end
      else
        char char
      end
      reader
    end

    def date_and_time
      short_day_name
      char ' '
      short_month_name
      char ' '
      day_of_month_blank_padded
      char ' '
      twenty_four_hour_time_with_seconds
      char ' '
      year
    end

    def date
      month_zero_padded
      char '/'
      day_of_month_zero_padded
      char '/'
      year_modulo_100
    end

    def year_month_day
      year
      char '-'
      month_zero_padded
      char '-'
      day_of_month_zero_padded
    end

    def twelve_hour_time
      hour_12_zero_padded
      char ':'
      minute
      char ':'
      second
      char ' '
      am_pm_upcase
    end

    def twenty_four_hour_time
      hour_24_zero_padded
      char ':'
      minute
    end

    def twenty_four_hour_time_with_seconds
      hour_24_zero_padded
      char ':'
      minute
      char ':'
      second
    end
  end
end
