function [tracksFinal,combined] = reverse_gap_close(tracksFinal, offset, distance)
    combined = 0;
    for j = numel(tracksFinal):-1:1
        for  i = (numel(tracksFinal)-1):-1:1
            if tracksFinal(j).Initial > tracksFinal(i).Final && (tracksFinal(j).Initial- offset) < (tracksFinal(i).Final) && tracksFinal(j).show == 1 && tracksFinal(i).show == 1
%                 dist = pdist([tracksFinal(i).X(length(tracksFinal(i).X)) tracksFinal(i).Y(length(tracksFinal(i).Y)) tracksFinal(i).Z(length(tracksFinal(i).Z)); tracksFinal(j).X(1) tracksFinal(j).Y(1) tracksFinal(j).Z(1)]);
                dist = pdist([tracksFinal(i).X(length(tracksFinal(i).X)) tracksFinal(i).Y(length(tracksFinal(i).Y)); tracksFinal(j).X(1) tracksFinal(j).Y(1)]);
                if dist <= distance
                    tracksFinal(i).Final = tracksFinal(j).Final;
                    tracksFinal(i).X = [tracksFinal(i).X tracksFinal(j).X];
                    tracksFinal(i).Y = [tracksFinal(i).Y tracksFinal(j).Y];
                    tracksFinal(i).Z = [tracksFinal(i).Z tracksFinal(j).Z];
                    tracksFinal(j).show = 0;
                    combined = combined + 1;
                end
            end
        end
    end
end 
