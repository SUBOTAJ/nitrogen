-module (wf_platform_mochiweb).
-export ([
	get_raw_path/0,
	get_querystring/0,
	request_method/0,
	
	parse_get_args/0,
	parse_post_args/0,
	
	get_cookie/1,
	create_cookie/4,
	
	create_header/2,
	
	build_response/0
]).



%%% PATH, METHOD, AND ARGS %%%

get_raw_path() ->
	Req = wf_platform:get_request(),
	Req:get(raw_path).

get_querystring() ->
	Req = wf_platform:get_request(),
	RawPath = Req:get(raw_path),
	{_, QueryString, _} = mochiweb_util:urlsplit_path(RawPath),
	QueryString.
	
request_method() ->
	Req = wf_platform:get_request(),
	Req:get(method).

parse_get_args() ->
	Req = wf_platform:get_request(),
	Req:parse_qs().
	
parse_post_args() ->
	Req = wf_platform:get_request(),
	Req:parse_post().
	
	
	
%%% COOKIES %%%
	
get_cookie(Key) ->
	Req = wf_platform:get_request(), 
	Req:get_cookie_value(Key).

create_cookie(Key, Value, Path, MinutesToLive) ->
	SecondsToLive = MinutesToLive * 60,
	mochiweb_cookies:cookie(Key, Value, [{path, Path}, {max_age, SecondsToLive}]).



%%% HEADERS %%%
create_header(Key, Value) ->
	{Key, Value}.


	
%%% RESPONSE %%%

build_response() ->
	Req = wf_platform:get_request(),
	
	% Prepare the body...
	ContentType = get(wf_content_type),
	Body = get(wf_response_body),
	Body1 = case ContentType of
		"text/html" -> 
			Script = wf_script:get_script(),
			wf_platform:inject_script(Body, Script);
		_ -> 
			wf_platform:set_header("Content-Type", ContentType),
			Body
	end,
	
	% Get headers...
	Code = get(wf_response_code),
	Headers = get(wf_headers),
	
	% Respond.
	Req:respond({Code, Headers, Body1}).
