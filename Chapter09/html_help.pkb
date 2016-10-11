create or replace PACKAGE BODY HTML_HELP as
/*
html_help.pkb
by Donald J. Bales on 12/15/2006
Package to create HTML-based help files for packages
*/

-- TYPES

TYPE spec_record is record (
line_type                             varchar2(1),
line_number                           number,
line_text                             varchar2(2000),
method_name                           varchar2(2000),
first_sentence                        varchar2(2000));

TYPE spec_table is table of spec_record index by binary_integer;

TYPE buffer_table is table of varchar2(2000) index by binary_integer;

-- CONSTANTS

v_LT_COMMENT                constant  varchar2(1) := 'C';
v_LT_METHOD                 constant  varchar2(1) := 'M';
v_LT_OTHER                  constant  varchar2(1) := 'O';

-- FORWARD DECLARATIONS

FUNCTION get_comment_start(
aiv_text                       in     varchar2)
return                                number;


FUNCTION get_comment_end(
aiv_text                       in     varchar2)
return                                number;


FUNCTION get_method_end(
aiv_text                       in     varchar2)
return                                number;


FUNCTION get_method_name_start(
aiv_text                       in     varchar2)
return                                number;


FUNCTION get_method_name_end(
aiv_text                       in     varchar2)
return                                number;


FUNCTION is_comment_start(
aiv_text                       in     varchar2)
return                                boolean;


FUNCTION is_comment_end(
aiv_text                       in     varchar2)
return                                boolean;


FUNCTION is_method_end(
aiv_text                       in     varchar2)
return                                boolean;


PROCEDURE out(
aiv_text                       in     varchar2);


PROCEDURE open_html(
aiv_title                      in     varchar2);


PROCEDURE close_html;


-- FUNCTIONS

FUNCTION get_comment_line_text(
aiv_text                       in     varchar2)
return                                varchar2 is

n_start                               number := 1;
n_end                                 number;

begin
  if is_comment_start(aiv_text) then
    n_start := get_comment_start(aiv_text);
  end if;
  if is_comment_end(aiv_text) then
    n_end := get_comment_end(aiv_text);
  else  
    n_end := nvl(length(aiv_text), 0);
  end if;
  if n_end > n_start then
    return substr(aiv_text, n_start, (n_end + 1) - n_start);
  else
    return NULL;
  end if;
end get_comment_line_text;


FUNCTION get_comment_end(
aiv_text                       in     varchar2)
return                                number is

n_position                            number;

begin
  n_position := nvl(instr(upper(aiv_text), '*/'), 0);
  if n_position > 0 then   
    return n_position - 1;    
  else
    n_position := nvl(instr(upper(aiv_text), '--'), 0);
    if n_position > 0 then   
      return nvl(length(aiv_text), 0);
    else
      return -1;
    end if;
  end if;
end get_comment_end;


FUNCTION get_comment_start(
aiv_text                       in     varchar2)
return                                number is

n_position                            number;

begin
  n_position := nvl(instr(upper(aiv_text), '/*'), 0);
  if n_position > 0 then   
    return n_position + 2;    
  else
    n_position := nvl(instr(upper(aiv_text), '--'), 0);
    if n_position > 0 then   
      return n_position + 2;    
    else
      return -1;
    end if;
  end if;
end get_comment_start;


FUNCTION get_first_sentence(
aiv_text                       in     varchar2)
return                                varchar2 is

n_start                               number := 1;
n_end                                 number;

begin
  if is_comment_start(aiv_text) then
    n_start := get_comment_start(aiv_text);
  end if;
  n_end := nvl(instr(aiv_text, '.') - 1, -1);
  if n_end = -1 then
    n_end := nvl(length(aiv_text), 0);
  end if;
  if n_end > n_start then
    return substr(aiv_text, n_start, (n_end + 1) - n_start);
  else
    return NULL;
  end if;
end get_first_sentence;


FUNCTION get_method_end(
aiv_text                       in     varchar2)
return                                number is

n_position                            number;

begin
  n_position := nvl(instr(upper(aiv_text), ';'), 0);
  if n_position > 0 then   
    return n_position - 1;    
  else
    return length(aiv_text);
  end if;
end get_method_end;


FUNCTION get_method_line_text(
aiv_text                       in     varchar2)
return                                varchar2 is

n_start                               number := 1;
n_end                                 number;

begin
  if is_method_end(aiv_text) then
    n_end := get_method_end(aiv_text);
  else  
    n_end := nvl(length(aiv_text), 0);
  end if;
  if n_end > 0 then
    return substr(aiv_text, n_start, (n_end + 1) - n_start);
  else
    return NULL;
  end if;
end get_method_line_text;


FUNCTION get_method_name(
aiv_text                       in     varchar2)
return                                varchar2 is

n_first                               number;
n_end                                 number;

begin
  n_first := get_method_name_start(aiv_text);
  n_end   := get_method_name_end(aiv_text);
  if n_end > n_first then
    return substr(aiv_text, n_first, (n_end + 1) - n_first);
  else
    return NULL;
  end if;
end get_method_name;


FUNCTION get_method_name_start(
aiv_text                       in     varchar2)
return                                number is

n_position                            number;

begin
  n_position := nvl(instr(upper(aiv_text), 'FUNCTION '), 0);
  if n_position > 0 then   
    return n_position + 9;    
  else
    n_position := nvl(instr(upper(aiv_text), 'PROCEDURE '), 0);
    if n_position > 0 then
      return n_position + 10;
    else
      return 0;
    end if;
  end if;
end get_method_name_start;


FUNCTION get_method_name_end(
aiv_text                       in     varchar2)
return                                number is

n_position                            number;

begin
  n_position := nvl(instr(upper(aiv_text), '('), 0);
  if n_position > 0 then   
    return n_position - 1;    
  else
    n_position := get_method_end(aiv_text);
    if n_position > 0 then
      return n_position;
    else
      return nvl(length(aiv_text), 0);
    end if;
  end if;
end get_method_name_end;


FUNCTION is_comment_end(
aiv_text                       in     varchar2)
return                                boolean is

n_position                            number;

begin
  if get_comment_end(aiv_text) >= 0 then
    return TRUE;
  else
    return FALSE;
  end if;
end is_comment_end;


FUNCTION is_comment_start(
aiv_text                       in     varchar2)
return                                boolean is

n_position                            number;

begin
  if get_comment_start(aiv_text) >= 0 then
    return TRUE;
  else
    return FALSE;
  end if;
end is_comment_start;


FUNCTION is_method_end(
aiv_text                       in     varchar2)
return                                boolean is

n_position                            number;

begin
  if nvl(instr(aiv_text, ';'), 0) > 0 then
    return TRUE;
  else
    return FALSE;
  end if;
end is_method_end;


FUNCTION is_method_start(
aiv_text                       in     varchar2)
return                                boolean is

n_position                            number;

begin
  if get_method_name_start(aiv_text) > 0 then
    return TRUE;
  else
    return FALSE;
  end if;
end is_method_start;


FUNCTION comments_span(
aiv_text                       in     varchar2) 
return                                varchar2 is
begin
  return '<span class="comments_span">'||aiv_text||'</span>';
end comments_span;


FUNCTION first_sentence_span(
aiv_text                       in     varchar2) 
return                                varchar2 is
begin
  return '<span class="first_sentence_span">'||aiv_text||'</span>';  
end first_sentence_span;


FUNCTION method_span(
aiv_text                       in     varchar2) 
return                                varchar2 is
begin
  return '<span class="method_span">'||aiv_text||'</span>';  
end method_span;


FUNCTION method_name_span(
aiv_text                       in     varchar2) 
return                                varchar2 is
begin
  return '<span class="method_name_span">'||aiv_text||'</span>';  
end method_name_span;


FUNCTION package_name_span(
aiv_text                       in     varchar2) 
return                                varchar2 is
begin
  return '<span class="package_name_span">'||aiv_text||'</span>';  
end package_name_span;


PROCEDURE create_index is

cursor c1 is
select distinct name
from   SYS.USER_SOURCE
where  type in ('PACKAGE', 'TYPE')
order by 1;

cursor c2(
aiv_name                       in     varchar2) is
select text
from   SYS.USER_SOURCE
where  type in ('PACKAGE', 'TYPE')
and    name = aiv_name
order by line;

b_comment                             boolean;
n_period                              number;

begin
  open_html('Package/Type index');
  out('<h2>Owner '||user||'</h2>');
  out('<table>');
  for r1 in c1 loop
    if c1%rowcount = 1 then
      out('<tr><th colspan="2">Packages/Types</th></tr>');
    end if;
    b_comment := FALSE;
    for r2 in c2(r1.name) loop
      if nvl(instr(r2.text, '/*'), 0) > 0 or
         nvl(instr(r2.text, '--'), 0) > 0 then
        b_comment := TRUE;
      end if;
      if b_comment                                               and
         nvl(instr(upper(r2.text), '.PKS'), 0) = 0               and
         substr(upper(ltrim(r2.text)), 1, 3)  <> 'BY '           and
         substr(upper(ltrim(r2.text)), 1, 13) <> 'COPYRIGHT BY ' then
        n_period := nvl(instr(ltrim(r2.text), '.'), 0);
        if n_period > 0 then
          out('<tr><td class="package_name_td"><a href="'||lower(r1.name)||'.html">'||package_name_span(r1.name)||'</a></td><td class="comments_td">'||comments_span(substr(ltrim(r2.text), 1, n_period))||'</td></tr>');   
          exit;
        end if;
      end if;
    end loop;
  end loop;
  out('</table>');
  close_html();
end create_index;


PROCEDURE create_help(
aiv_object_name                in     varchar2) is

cursor c1(
aiv_object_name                in     varchar2) is
select text,
       type
from   SYS.USER_SOURCE
where  name = upper(aiv_object_name)
and    type in ('PACKAGE', 'TYPE')
and    line > 1
order by line;

b_comment                             boolean := FALSE;
b_first_sentence                      boolean := FALSE;
b_method                              boolean := FALSE;
b_method_name                         boolean := FALSE;
b_other                               boolean := FALSE;
n_backward                            number;
n_line_number                         number;
n_spec                                number := 0;
t_spec                                spec_table;
v_comment                             varchar2(2000);
v_first_sentence                      varchar2(2000);
v_method                              varchar2(2000);
v_method_name                         varchar2(2000);
v_text                                varchar2(2000);
v_type                                varchar2(30);

begin
  for r1 in c1(aiv_object_name) loop
    if c1%rowcount = 1 then
      v_type := r1.type;
    end if;
    
    -- strip away any carriage-returns and line-feeds
    v_text := replace(replace(r1.text, chr(13), NULL), chr(10), NULL);
    -- detect comments and methods
    if    is_comment_start(v_text) then
      b_comment                         := TRUE;
      b_first_sentence                  := FALSE;
      if not b_first_sentence then
        v_first_sentence                := get_first_sentence(v_text);
        if v_first_sentence is not NULL then
          b_first_sentence              := TRUE;
          n_line_number                 := 1;
          n_spec                        := n_spec + 1;
          t_spec(n_spec).line_type      := v_LT_COMMENT;
          t_spec(n_spec).line_number    := n_line_number;
          t_spec(n_spec).line_text      := get_comment_line_text(v_text);
          t_spec(n_spec).first_sentence := v_first_sentence;
        end if;
      else
        v_comment                       := get_comment_line_text(v_text);
        if v_comment is not NULL then
          n_line_number                 := 1;
          n_spec                        := n_spec + 1;
          t_spec(n_spec).line_type      := v_LT_COMMENT;
          t_spec(n_spec).line_number    := n_line_number;
          t_spec(n_spec).line_text      := get_comment_line_text(v_text);
          t_spec(n_spec).first_sentence := NULL;
        end if;
      end if;
      if is_comment_end(v_text) then
        b_comment                       := FALSE;
        b_first_sentence                := FALSE;
      end if;
    elsif b_comment              and
          is_comment_end(v_text) then
      if not b_first_sentence then
        v_first_sentence                := get_first_sentence(v_text);
        if v_first_sentence is not NULL then
          b_first_sentence              := TRUE;
          n_line_number                 := 1;
          n_spec                        := n_spec + 1;
          t_spec(n_spec).line_type      := v_LT_COMMENT;
          t_spec(n_spec).line_number    := n_line_number;
          t_spec(n_spec).line_text      := get_comment_line_text(v_text);
          t_spec(n_spec).first_sentence := v_first_sentence;
        end if;
      else
        v_comment                     := get_comment_line_text(v_text);
        if v_comment is not NULL then
          n_line_number                 := n_line_number + 1;
          n_spec                        := n_spec + 1;
          t_spec(n_spec).line_type      := v_LT_COMMENT;
          t_spec(n_spec).line_number    := n_line_number;
          t_spec(n_spec).line_text      := get_comment_line_text(v_text);
          t_spec(n_spec).first_sentence := NULL;
        end if;
      end if;      
      b_comment                         := FALSE;
      b_first_sentence                  := FALSE;
    elsif b_comment                                        then
      if not b_first_sentence then
        v_first_sentence                := get_first_sentence(v_text);
        if v_first_sentence is not NULL then
          b_first_sentence              := TRUE;
          n_line_number                 := 1;
          n_spec                        := n_spec + 1;
          t_spec(n_spec).line_type      := v_LT_COMMENT;
          t_spec(n_spec).line_number    := n_line_number;
          t_spec(n_spec).line_text      := get_comment_line_text(v_text);
          t_spec(n_spec).first_sentence := v_first_sentence;
        end if;
      else
        v_comment                     := get_comment_line_text(v_text);
        if v_comment is not NULL then
          n_line_number                 := n_line_number + 1;
          n_spec                        := n_spec + 1;
          t_spec(n_spec).line_type      := v_LT_COMMENT;
          t_spec(n_spec).line_number    := n_line_number;
          t_spec(n_spec).line_text      := get_comment_line_text(v_text);
          t_spec(n_spec).first_sentence := NULL;
        end if;
      end if;      
    elsif is_method_start(v_text) then
      b_method                          := TRUE;
      b_method_name                     := FALSE;
      if not b_method_name then
        v_method_name                   := get_method_name(v_text);
        if v_method_name is not NULL then
          b_method_name                 := TRUE;
          n_line_number                 := 1;
          n_spec                        := n_spec + 1;
          t_spec(n_spec).line_type      := v_LT_METHOD;
          t_spec(n_spec).line_number    := n_line_number;
          t_spec(n_spec).line_text      := get_method_line_text(v_text);
          t_spec(n_spec).method_name    := v_method_name;
        else
          n_line_number                 := 1;
          n_spec                        := n_spec + 1;
          t_spec(n_spec).line_type      := v_LT_METHOD;
          t_spec(n_spec).line_number    := n_line_number;
          t_spec(n_spec).line_text      := get_method_line_text(v_text);
          t_spec(n_spec).method_name    := NULL;
        end if;
      else
        v_method                        := get_method_line_text(v_text);
        if v_method is not NULL then
          n_line_number                 := n_line_number + 1;
          n_spec                        := n_spec + 1;
          t_spec(n_spec).line_type      := v_LT_METHOD;
          t_spec(n_spec).line_number    := n_line_number;
          t_spec(n_spec).line_text      := v_method;
          t_spec(n_spec).method_name    := NULL;
        end if;
      end if;
      if is_method_end(v_text) then
        b_method                        := FALSE;
        b_method_name                   := FALSE;
      end if;
    elsif b_method              and
          is_method_end(v_text) then
      if not b_method_name then
        v_method_name                   := get_method_name(v_text);
        if v_method_name is not NULL then
          b_method_name                 := TRUE;
          n_line_number                 := 1;
          n_spec                        := n_spec + 1;
          t_spec(n_spec).line_type      := v_LT_METHOD;
          t_spec(n_spec).line_number    := n_line_number;
          t_spec(n_spec).line_text      := get_method_line_text(v_text);
          t_spec(n_spec).method_name    := v_method_name;
        else
          n_line_number                 := 1;
          n_spec                        := n_spec + 1;
          t_spec(n_spec).line_type      := v_LT_METHOD;
          t_spec(n_spec).line_number    := n_line_number;
          t_spec(n_spec).line_text      := get_method_line_text(v_text);
          t_spec(n_spec).method_name    := NULL;
        end if;
      else
        v_method                        := get_method_line_text(v_text);
        if v_method is not NULL then
          n_line_number                 := n_line_number + 1;
          n_spec                        := n_spec + 1;
          t_spec(n_spec).line_type      := v_LT_METHOD;
          t_spec(n_spec).line_number    := n_line_number;
          t_spec(n_spec).line_text      := v_method;
          t_spec(n_spec).method_name    := NULL;
        end if;
      end if;
      b_method                          := FALSE;
      b_method_name                     := FALSE;
    elsif b_method                                         then
      v_method                          := get_method_line_text(v_text);
      if v_method is not NULL then
        n_line_number                   := n_line_number + 1;
        n_spec                          := n_spec + 1;
        t_spec(n_spec).line_type        := v_LT_METHOD;
        t_spec(n_spec).line_number      := n_line_number;
        t_spec(n_spec).line_text        := v_method;
        t_spec(n_spec).method_name      := NULL;
      end if;
    elsif upper(substr(ltrim(v_text), 1, 3)) = 'END'       then
      exit;
    elsif nvl(length(rtrim(v_text)), 0) > 0 then
      n_line_number                     := 1;
      n_spec                            := n_spec + 1;
      t_spec(n_spec).line_type          := v_LT_OTHER;
      t_spec(n_spec).line_number        := n_line_number;
      t_spec(n_spec).line_text          := v_text;
    end if;
  end loop;

  -- Now create the HTML
  open_html(aiv_object_name);
  -- Package name and comments
  if v_type = 'PACKAGE' then 
    out('<h2>Package '||upper(aiv_object_name)||'</h2>');
  else
    out('<h2>Type '||upper(aiv_object_name)||'</h2>');
  end if;
  if n_spec > 0 then
    for i in 1..n_spec loop
      if t_spec(i).first_sentence is not NULL then
        out('<p class="comments_p">');
        n_line_number := t_spec(i).line_number;
        for j in i..n_spec loop
          if j                      > 1             and
             t_spec(j).line_number <= n_line_number then
            exit;
          end if;
          out(t_spec(j).line_text);
        end loop;
        out('</p>');
        exit;
      end if;
    end loop;
    out('<hr/><br/>');
    -- Other
    for i in 1..n_spec loop
      if t_spec(i).line_type = v_LT_OTHER then
        if not b_other then
          out('<table>');
          if v_type = 'PACKAGE' then
            out('<tr><th colspan="2">Global Constants and Variables</th></tr>');
          else
            out('<tr><th colspan="2">Attributes</th></tr>');
          end if;
          out('</table>');
          out('<pre class="other_pre">');
          b_other := TRUE;
        end if;
        if i > 1                                 and
          t_spec(i - 1).line_type = v_LT_COMMENT then
          n_backward := i - t_spec(i - 1).line_number;
          if n_backward > 0 then
            out('</pre><p class="comments_p">');
            for j in n_backward..(i - 1) loop
              out(t_spec(j).line_text);
            end loop;
            out('</p><pre class="other_pre">');
          end if;
        end if;
        out(t_spec(i).line_text);
      end if;
    end loop;
    if b_other then
      out('</pre>');
      out('<hr/><br/>');
    end if;
/*    -- Debug Output
    out('<!--');
    out('<h2>Debug Output</h2>');
    for i in 1..n_spec loop
      if i = 1 then
        out('<table>');
        out('<tr><th>line_type</th><th>line_number</th><th>line_text</th><th>first_sentence</th><th>method_name</th></tr>');
      end if;
      out('<tr><td>'||t_spec(i).line_type||'</td><td>'||t_spec(i).line_number||'</td><td>'||t_spec(i).line_text||'</td><td>'||t_spec(i).first_sentence||'</td><td>'||t_spec(i).method_name||'</td></tr>');
      if i = n_spec then
        out('</table>');
        out('<hr/>');
      end if;
    end loop;
    out('<hr/><br/>');
    out('-->');  */
    -- Method Summary
    out('<table>');
    out('<tr><th colspan="2">Method Summary</th></tr>');
    for i in 1..n_spec loop
      if t_spec(i).method_name is not NULL then
        v_first_sentence := '<br/>';
        n_backward := i - 1;
        if n_backward > 0 then
          loop
            if t_spec(n_backward).method_name is not NULL then 
              exit;
            end if;
            if t_spec(n_backward).first_sentence is not NULL then
              v_first_sentence := t_spec(n_backward).first_sentence;
              exit;
            end if;
            n_backward := n_backward - 1;
            if n_backward < 1 then
              exit;
            end if;
          end loop;
        end if;
        out('<tr><td class="method_name_td"><a href="#'||t_spec(i).method_name||'_'||to_char(i)||'">'||method_name_span(t_spec(i).method_name)||'</a></td>');
        out('    <td class="first_sentence_td">'||first_sentence_span(nvl(v_first_sentence, '<br/>'))||'</td></tr>');
      end if;
    end loop;
    out('</table>');
    out('<br/><hr/><br/>');
    -- Method Details
    out('<table>');
    out('<tr><th colspan="2">Method Detail</th></tr>');
    out('</table>');
    for i in 1..n_spec loop
      if t_spec(i).method_name is not NULL then
        out('<h3><a name="#'||t_spec(i).method_name||'_'||to_char(i)||'">'||t_spec(i).method_name||'</a></h3>');
        out('<pre class="method_pre">');
        for j in i..n_spec loop
          if t_spec(j).line_type <> v_LT_METHOD or
            (j > i                              and 
             t_spec(j).method_name is not NULL) then
            exit;
          end if;
          out(t_spec(j).line_text);
        end loop;
        out('</pre>');
        if i > 1                                 and
          t_spec(i - 1).line_type = v_LT_COMMENT then
          n_backward := i - t_spec(i - 1).line_number;
          if n_backward > 0 then
            out('<p class="comments_p">');
            for j in n_backward..(i - 1) loop
              out(t_spec(j).line_text);
            end loop;
            out('</p>');
          end if;
        end if;
        out('<hr/>');
      end if;
    end loop;
  end if;
  close_html();
end create_help;


PROCEDURE help is

begin
  TEXT_HELP.process('HTML_HELP');
end help;


PROCEDURE out(
aiv_text                       in     varchar2) is

TYPE split_table is table of varchar2(255) 
index by binary_integer;

n_length                              number;
n_split                               number := 255;
n_start                               number := 1;
n_stop                                number;
n_text                                number := 0;

t_text                                split_table;

n_limit_1                             number := 0;
n_limit_2                             number := 0;

begin
  n_length := nvl(length(aiv_text), 0);
  
  if n_length > 255 then
    loop
      n_limit_1 := n_limit_1 + 1;
      n_stop := least(n_start + n_split, n_length);
      loop
        n_limit_2 := n_limit_2 + 1;
      
        if    n_stop = n_start then
          n_stop := n_length;
          exit;
        elsif substr(aiv_text, n_stop, 1) = chr(32) then
          exit;
        else
          n_stop := n_stop - 1;
        end if;
      end loop;    
      n_text := n_text + 1;
      t_text(n_text) := substr(aiv_text, n_start, n_stop - n_start);
      n_start := n_stop;
      if n_start >= n_length then
        exit;
      end if;
    end loop;
    for i in t_text.first..t_text.last loop
      SYS.DBMS_OUTPUT.put_line(t_text(i));
    end loop;
  else
    SYS.DBMS_OUTPUT.put_line(aiv_text);
  end if;
end out;


PROCEDURE open_html(
aiv_title                      in     varchar2) is

begin
  out('<html>
<head>
<title>'||aiv_title||'</title>
<link rel="stylesheet" type="text/css" href="stylesheet.css"/>
</head>
<body>');
end open_html;


PROCEDURE close_html is

begin
  out('</body>
</html>');
end close_html;


PROCEDURE test is

begin
  pl('HTML_HELP.test()');
  
  TEST_TS.clear('HTML_HELP');
  
  TEST_TS.set_test('HTML_HELP', 'create_package_index()', 1, 
    'Test method create_package_index()' );
  begin
    create_index();
    
    TEST_TS.ok();
  exception
    when OTHERS then
      TEST_TS.error(SQLERRM);
  end;
  
  TEST_TS.set_test('HTML_HELP', 'create_package_help()', 2, 
    'Test method create_package_help()' );
  begin
    create_help('HTML_HELP');
    
    TEST_TS.ok();
  exception
    when OTHERS then
      TEST_TS.error(SQLERRM);
  end;
  
  TEST_TS.set_test('HTML_HELP', 'help()', 3, 
    'Test method help()' );
  begin
    help();
    
    TEST_TS.ok();
  exception
    when OTHERS then
      TEST_TS.error(SQLERRM);
  end;
  
  TEST_TS.set_test('HTML_HELP', NULL, NULL, NULL);
  TEST_TS.success();
end test;


end HTML_HELP;
/
@be.sql HTML_HELP
