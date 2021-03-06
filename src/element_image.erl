% Nitrogen Web Framework for Erlang
% Copyright (c) 2008 Rusty Klophaus
% See MIT-LICENSE for licensing information.

-module (element_image).
-include ("wf.inc").
-compile(export_all).

render(ControlID, Record) -> 
	wf:f("<img id='~s' class='span ~s' style='~s' src='~s'>", [
		ControlID,
		Record#image.class,
		Record#image.style,
		Record#image.image
	]).