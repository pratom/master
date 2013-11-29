Add-Type @'
namespace pratom 
{
    public class LogLine
    {
        private int         m_id                 = 0;
        private string      m_date_as_string    = "";
        private string      m_category          = "";
        public LogLine( int id, string date_as_string, string category)
        {
            m_id = id;
            m_date_as_string = date_as_string;
            m_category = category;    
        }
        private char        m_indent_character = ' ';
        private string      m_data = "";
        public string Data
        {
            get { return m_data ; }
            set { m_data = value ; }
        }

        private string      m_format_PRL_TAG_OPEN        = "<PRL id='{pratom_logger_line_id}'  dtt='{pratom_logger_line_date}' cat='{pratom_logger_category}'>";
        private string      m_format_PRL_TAG_CLOSED      = "</PRL>";

        
        public string Format
        {
            get 
            { 
                return ( m_format_PRL_TAG_OPEN + "{log_data}" + m_format_PRL_TAG_CLOSED ) ; 
            }
        }

        public string Formatted 
        {
            get { 
                return Formatted_SANS_Data.Replace("{log_data}", Data_indented);
            } 
        }

        public string Formatted_SANS_Data 
        {
            get 
            { 
                return 
                    ( 
                        ( prl_tag_open_formatted + "{log_data}" + m_format_PRL_TAG_CLOSED )
                    );
            } 
        }


        private string prl_tag_open_formatted
        {
            get 
            { 
                return ( m_format_PRL_TAG_OPEN.Replace("{pratom_logger_line_id}", m_id.ToString().PadLeft(6, ' ')).Replace("{pratom_logger_line_date}", m_date_as_string).Replace("{pratom_logger_category}", m_category) );
            } 
        }

        private string Data_indented
        {
            get { 
                string nl = System.Environment.NewLine;
                int indent = ((prl_tag_open_formatted.Length));
                string s_indent = (new string(m_indent_character, indent));
                string new_nl = (nl + s_indent);
                string s1 = Data.Replace(nl, new_nl);
                return s1;
            }
        }
    }
}
'@