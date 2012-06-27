function opt2dot(opt, filename)
% Produce a GraphViz .dot file from an Optickle model.

% The .dot format is documented here:
% http://www.graphviz.org/Documentation/dotguide.pdf

if nargin < 2
    fid = 1;
else
    fid = fopen(filename, 'w');
end

fprintf(fid, 'digraph G {\n');
% output the optics (graph nodes)
for snOptic=1:opt.Noptic,
    optic = opt.optic{snOptic};
    fprintf(fid, '    %s', optic.name);
    switch class(optic)
        case 'Sink',
            fprintf(fid, ' [shape=box]');
    end
    fprintf(fid, ';\n');
end
% output the links (graph edges)
for snLink=1:opt.Nlink,
    [A, src_sn, src_port] = getSourceName(opt, snLink);
    [A, snk_sn, snk_port] = getSinkName(opt, snLink);
    
    src_optic_name = getOpticName(opt, src_sn);
    snk_optic_name = getOpticName(opt, snk_sn);
    
    src_port_name = opt.optic{src_sn}.outNames{src_port}{1};
    snk_port_name = opt.optic{snk_sn}.inNames{snk_port}{1};
    
    fprintf(fid, '     %s:%s -> %s:%s [label="%s&rarr;%s"];\n', ...
        src_optic_name,src_port_name,  snk_optic_name , ...
         snk_port_name, ...
        src_port_name, snk_port_name);
       
end
% To-do: Draw the probes
fprintf(fid, '}\n');

if fid ~= 1
    fclose(fid);
end
end
