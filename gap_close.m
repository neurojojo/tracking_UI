fig = figure('color','k');
ax = arrayfun( @(x) subplot(1,2,x,'NextPlot','add',...
    'color','k','xcolor','w','ycolor','w'), [1:2] ) % Set up two subplots for side-by-side viewing
%hold on ('nextplot' flag handles this behavior);

for i = 1:size(TrackInfo, 2) %for each track
    % Add ax(1) as the axes upon which to plot
    plot3(ax(1), TrackInfo(i).X, TrackInfo(i).Y, TrackInfo(i).Z,'-','MarkerSize',2, 'Tag', num2str(i) )
end
%xlabel('Cell Location: X-Coordinate');
%ylabel('Cell Location: Y-Coordinate');
%zlabel('Video Frame');
title('Crude Tracks');

[test_out, combined] = gapCloseTracks(TrackInfo, 200, 8)

for i = 1:size(test_out, 2) %for each track
    if isempty(test_out(i).hide)
        % Add ax(2) as the axes upon which to plot
        plot3(ax(2), test_out(i).X, test_out(i).Y, test_out(i).Z,'-','MarkerSize',2, 'Tag', num2str(i)) % This overwrites (or duplicates the tags from before) -- use sprintf to create a string with the integer in it
    end
end
%xlabel('Cell Location: X-Coordinate');
%ylabel('Cell Location: Y-Coordinate');
%zlabel('Video Frame');
title('Gap Closed Tracks');
%hold off
arrayfun( @(x) set(x,'XLabel',text(0,0,'Cell Location: X-Coordinate'),'YLabel',text(0,0,'Cell Location: Y-Coordinate'),'ZLabel',text(0,0,'Video Frame')), ax );


% Adding a slider to "move through" a 3D representation of the data (see CaptureFigVid.m for details on how) %
hSlider = uicontrol('Parent',fig,...
    'Style','slider',...
    'Units','Normalize',...
    'Position',[0,0,1,0.05],...
    'min',0, 'max',1,...
    'Value', 0,...
    'SliderStep', [1/100,1/10]);
el = addlistener(hSlider, 'ContinuousValueChange', @(event,src) makeZoomPlots( ax, myfig, movieInfo, event.Value) );



function [tracksFinal,combined] = gapCloseTracks(tracksFinal, offset, distance)
    combined = 0;
    for i = 1:numel(tracksFinal)
        for j = i+1:numel(tracksFinal)
            if tracksFinal(j).Initial > tracksFinal(i).Final && tracksFinal(j).Initial <= (tracksFinal(i).Final + offset)
                dist = pdist([tracksFinal(i).X(length(tracksFinal(i).X)) tracksFinal(i).Y(length(tracksFinal(i).Y)) tracksFinal(i).Z(length(tracksFinal(i).Z)); tracksFinal(j).X(1) tracksFinal(j).Y(1) tracksFinal(j).Z(1)]);
                if dist <= distance
                    parent = tracksFinal(i).TrackIdx; %find which one to combine to
                    tracksFinal(parent).Final = tracksFinal(j).Final;
                    tracksFinal(parent).X = [tracksFinal(parent).X tracksFinal(j).X];
                    tracksFinal(parent).Y = [tracksFinal(parent).Y tracksFinal(j).Y];
                    tracksFinal(parent).Z = [tracksFinal(parent).Z tracksFinal(j).Z];
                    tracksFinal(j).TrackIdx = tracksFinal(i).TrackIdx;
                    tracksFinal(j).hide = true;
                    combined = combined + 1;
                end
            end
        end
    end
end 

