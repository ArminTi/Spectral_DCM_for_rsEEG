function data = rseeg_segment(data)

% segment it into 1-second pieces
cfg = [];
cfg.length               = 2; % second
data           = ft_redefinetrial(cfg, data);


end