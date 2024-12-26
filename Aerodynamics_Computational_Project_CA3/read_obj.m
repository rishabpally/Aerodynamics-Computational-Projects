function [facets, vertices]=  read_obj(fileName)
%opens/reads file. reads line by line
x= fopen(fileName);
nline= fgetl(x);
i= 1;
j= 1;

%using a while loop, we are able to determine whether it falls under a
%facet or vertices, else skip the line, then close the file
while ischar(nline)
    facet2_line= nline(2:end);
    if nline(1)== 'v'
        vertices(i, 1:3)= sscanf(facet2_line, '%f');
        i=i+1;
        nline = fgetl(x);
    elseif nline(1)== 'f'
        facets(j, 1:3)= sscanf(facet2_line, '%f');
        j=j+1;
        nline= fgetl(x);
    else
        nline= fgetl(x);
    end
end
end