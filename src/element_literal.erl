% Nitrogen Web Framework for Erlang
% Copyright (c) 2008 Rusty Klophaus
% See MIT-LICENSE for licensing information.

-module (element_literal).
-compile(export_all).
-include ("wf.inc").

render(_ControlID, Record) -> 
	wf:html_encode(Record#literal.text, Record#literal.html_encode).