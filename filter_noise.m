function TrackInfo = filter_noise(TrackInfo, threshold)
    disp(threshold);
    TrackInfo(([TrackInfo.Final]-[TrackInfo.Initial]) < threshold) = [];
    disp(numel(TrackInfo));
end