function [ matched ] = matchWords( imageVisualWords1, imageVisualWords2 )
    [matched, matchedIdx] = ismember(imageVisualWords1, imageVisualWords2);
    matched = [find(matched);...
               matchedIdx(matched)];


end

