fig = figure;
hold on

for i = 1:size(TrackInfo, 2) %for each track
    
    plot3(TrackInfo(i).X, TrackInfo(i).Y, TrackInfo(i).Z,'-o','MarkerSize',2, 'Tag', num2str(i))
end
xlabel('Cell Location: X-Coordinate');
ylabel('Cell Location: Y-Coordinate');
zlabel('Video Frame');
title('Crude Tracks');
hold off

[test_out, combined] = gapCloseTracks(TrackInfo, 200, 8)

fig2 = figure;
hold on
for i = 1:size(test_out, 2) %for each track
    if isempty(test_out(i).hide)
        plot3(test_out(i).X, test_out(i).Y, test_out(i).Z,'-o','MarkerSize',2, 'Tag', num2str(i))
    end
end
xlabel('Cell Location: X-Coordinate');
ylabel('Cell Location: Y-Coordinate');
zlabel('Video Frame');
title('Gap Closed Tracks');
hold off

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
