create or replace package body EMAILS as
/*
emails.pkb
by Donald J. Bales on 12/15/2006
Package to send emails
*/

v_host                                varchar2(30) := 'smtp.sbcglobal.yahoo.com';
v_domain                              varchar2(30) := 'sbcglobal.net';
v_username                            varchar2(30) := '<your email address>';
v_password                            varchar2(30) := '<your email address password';


FUNCTION get_domain
return                                varchar2 is

begin
  return v_domain;
end get_domain;


FUNCTION get_host
return                                varchar2 is

begin
  return v_host;
end get_host;


FUNCTION get_username
return                                varchar2 is

begin
  return v_username;
end get_username;


PROCEDURE send(
aiv_from                       in     varchar2,
aiv_to                         in     varchar2,
aiv_subject                    in     varchar2,
ait_lines                      in     lines) is

n_close_data                          number;
n_log                                 number := 0;
r_connection                          UTL_SMTP.CONNECTION;
r_decoded                             raw(80);
r_encoded                             raw(80);
r_reply                               UTL_SMTP.REPLY;
t_reply                               UTL_SMTP.REPLIES;
t_log                                 lines;
v_close_data                          varchar2(255);
v_decoded                             varchar2(160);
v_encoded                             varchar2(160);
v_sqlerrm                             varchar2(255);

begin
  t_log(incr(n_log)) := 'open_connection';
  r_connection := UTL_SMTP.OPEN_CONNECTION(v_host);

  if v_password is null then
    t_log(incr(n_log)) := 'helo';
    r_reply := UTL_SMTP.HELO(r_connection, v_domain);
    t_log(incr(n_log)) := 'reply: '||r_reply.code||', '||r_reply.text;
  else
    t_log(incr(n_log)) := 'ehlo';
    t_reply := UTL_SMTP.EHLO(r_connection, v_domain);
    for i in t_reply.first..t_reply.last loop
      t_log(incr(n_log)) := 'reply: '||
        t_reply(i).code||', '||t_reply(i).text;
    end loop;

    t_log(incr(n_log)) := 'auth login';
    r_reply   := UTL_SMTP.command(r_connection, 'auth login');
    r_encoded := UTL_I18N.string_to_raw(r_reply.text, 'utf8');
    r_decoded := UTL_ENCODE.base64_decode(r_encoded);
    v_decoded := UTL_I18N.raw_to_char(r_decoded, 'utf8');
    t_log(incr(n_log)) := 'reply: '||r_reply.code||', '||v_decoded;

    r_encoded := UTL_ENCODE.base64_encode(
                   UTL_I18N.string_to_raw(v_username, 'utf8'));
    v_encoded := UTL_I18N.raw_to_char(r_encoded, 'utf8');
    t_log(incr(n_log)) := v_encoded;
    r_reply   := UTL_SMTP.command(r_connection, v_encoded);
    r_encoded := UTL_I18N.string_to_raw(r_reply.text, 'utf8');
    r_decoded := UTL_ENCODE.base64_decode(r_encoded);
    v_decoded := UTL_I18N.raw_to_char(r_decoded, 'utf8');
    t_log(incr(n_log)) := 'reply: '||r_reply.code||', '||v_decoded;
    r_encoded := UTL_ENCODE.base64_encode(
                   UTL_I18N.string_to_raw(v_password, 'utf8'));
    v_encoded := UTL_I18N.raw_to_char(r_encoded, 'utf8');
    t_log(incr(n_log)) := v_encoded;
    r_reply   := UTL_SMTP.command(r_connection, v_encoded);
    t_log(incr(n_log)) := 'reply: '||r_reply.code||', '||r_reply.text;
  end if;
  
  t_log(incr(n_log)) := 'mail';
  r_reply   := UTL_SMTP.MAIL(r_connection, v_username);
  t_log(incr(n_log)) := 'reply: '||r_reply.code||', '||r_reply.text;

  t_log(incr(n_log)) := 'rcpt';
  r_reply   := UTL_SMTP.RCPT(r_connection, aiv_to);
  t_log(incr(n_log)) := 'reply: '||r_reply.code||', '||r_reply.text;

  t_log(incr(n_log)) := 'open';
  r_reply := UTL_SMTP.OPEN_DATA(r_connection);
  t_log(incr(n_log)) := 'reply: '||r_reply.code||', '||r_reply.text;

  t_log(incr(n_log)) := 'From:';
  UTL_SMTP.WRITE_DATA(r_connection, 'From: '||aiv_from||UTL_TCP.crlf);
  t_log(incr(n_log)) := 'To:';
  UTL_SMTP.WRITE_DATA(r_connection, 'To: '||aiv_to||UTL_TCP.crlf);
  t_log(incr(n_log)) := 'Subject:';
  UTL_SMTP.WRITE_DATA(r_connection, 'Subject: '||aiv_subject||UTL_TCP.crlf);
  t_log(incr(n_log)) := 'MIME-Version:';
  UTL_SMTP.WRITE_DATA(r_connection, 'MIME-Version: 1.0'||UTL_TCP.crlf);
  t_log(incr(n_log)) := 'Content-Type:';
  UTL_SMTP.WRITE_DATA(r_connection, 'Content-Type: text/html'||UTL_TCP.crlf);
  t_log(incr(n_log)) := '<html><body><pre>...';
  UTL_SMTP.WRITE_DATA(r_connection, UTL_TCP.crlf);
  UTL_SMTP.WRITE_DATA(r_connection, '<html><body><pre>'||UTL_TCP.crlf);
  for i in ait_lines.first..ait_lines.last loop
    UTL_SMTP.WRITE_DATA(r_connection, ait_lines(i)||UTL_TCP.crlf);  
  end loop;
  t_log(incr(n_log)) := '...</pre></body></html>';
  UTL_SMTP.WRITE_DATA(r_connection, '</pre></body></html>'||UTL_TCP.crlf);

  t_log(incr(n_log)) := 'close_data';
  r_reply := UTL_SMTP.CLOSE_DATA(r_connection);
  t_log(incr(n_log)) := 'reply: '||r_reply.code||', '||r_reply.text;
  n_close_data       := r_reply.code;
  v_close_data       := r_reply.text;
  
  t_log(incr(n_log)) := 'quit';
  r_reply := UTL_SMTP.QUIT(r_connection);
  t_log(incr(n_log)) := 'reply: '||r_reply.code||', '||r_reply.text;

  if n_close_data <> 250 then
    for i in t_log.first..t_log.last loop
      EMAIL_LOGS.set_text(t_log(i));
    end loop;
    raise_application_error(-20000, 'Email not sent: '||
      to_char(n_close_data)||', '||v_close_data||' in EMAILS.send()');
  end if;
exception
  when UTL_SMTP.TRANSIENT_ERROR then
    v_sqlerrm := SQLERRM;
    for i in t_log.first..t_log.last loop
      EMAIL_LOGS.set_text(t_log(i));
    end loop;
    EMAIL_LOGS.set_text(v_sqlerrm);
    begin
      UTL_SMTP.quit(r_connection);
    exception
      when OTHERS then
        null;
    end;
    raise_application_error(-20001, v_sqlerrm||' in EMAILS.send()');
  when UTL_SMTP.PERMANENT_ERROR then
    v_sqlerrm := SQLERRM;
    for i in t_log.first..t_log.last loop
      EMAIL_LOGS.set_text(t_log(i));
    end loop;
    EMAIL_LOGS.set_text(v_sqlerrm);
    begin
      UTL_SMTP.quit(r_connection);
    exception
      when OTHERS then
        null;
    end;
    raise_application_error(-20002, v_sqlerrm||' in EMAILS.send()');
end send;


PROCEDURE set_domain(
aiv_domain                     in     varchar2) is

begin
  v_domain := aiv_domain;
end set_domain;


PROCEDURE set_host(
aiv_host                       in     varchar2) is

begin
  v_host := aiv_host;
end set_host;


PROCEDURE set_password(
aiv_password                   in     varchar2) is

begin
  v_password := aiv_password;
end set_password;


PROCEDURE set_username(
aiv_username                   in     varchar2) is

begin
  v_username := aiv_username;
end set_username;


PROCEDURE test is

t_lines                               LINES;
n_line                                number := 0;

begin
  t_lines(incr(n_line)) := '</pre>';
  t_lines(incr(n_line)) := '<h1>EMAILS.test()</h1>';
  t_lines(incr(n_line)) := 'Did you get this test message sent at '||
    to_char(SYSDATE, 'HH:MI:SS')||' on '||
    rtrim(to_char(SYSDATE, 'Day'))||', '||
    rtrim(to_char(SYSDATE, 'Month'))||' '||
    to_char(SYSDATE, 'DD, YYYY')||'?';
  t_lines(incr(n_line)) := '<pre>';
  send(
    '<to email address>',
    '<from email address>',
    'EMAILS.test()',
    t_lines);
end test;    


end EMAILS;
/
@be.sql EMAILS
