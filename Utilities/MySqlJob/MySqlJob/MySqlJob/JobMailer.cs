using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Net.Mail;
using System.Net;

namespace MySqlJob
{
    class JobMailer
    {
        private string email_to;
        private string email_from;
        private string password;
        private string email_smtp;
        private bool use_ssl;
        private int port;

        public void Send(string subject, string body)
        {
            MailMessage mail = new MailMessage(email_from, email_to);
            using (SmtpClient client = new SmtpClient
            {
                DeliveryMethod = SmtpDeliveryMethod.Network,
                UseDefaultCredentials = false,
                EnableSsl = use_ssl,
                Host = email_smtp,
                Timeout = 100000,
                Port = port,
                Credentials = new NetworkCredential(email_from, password)
            })
            {
                mail.Subject = subject;
                mail.Body = body;
                client.Send(mail);
            }

                
        }

        public JobMailer(string emailTo, string smtp, string emailFrom, string pw, int p, bool ssl)
        {
            email_to = emailTo;
            email_from = emailFrom;
            password = pw;
            email_smtp = smtp;
            port = p;
            use_ssl = ssl;
        }
       
    }
}
