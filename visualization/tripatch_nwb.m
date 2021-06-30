function handle=tripatch_nwb(struct, nofigure, varargin)

if nargin<2 | isempty(nofigure)
   figure
end% if
if nargin<3
   handle=trisurf(struct.faces, struct.vertices(:, 1), struct.vertices(:, 2), struct.vertices(:, 3));
else
   if isnumeric(varargin{1})
      col=varargin{1};
      varargin(1)=[];
      if [1 3]==sort(size(col))
         col=repmat(col(:)', [size(struct.vertices, 1) 1]);
      end% if
      handle=trisurf(struct.faces, struct.vertices(:, 1), struct.vertices(:, 2), struct.vertices(:, 3), ...
         'FaceVertexCData', col, varargin{:});
      if length(col)==size(struct.vertices, 1)
         set(handle, 'FaceColor', 'interp');
      end% if
   else
      handle=trisurf(struct.faces, struct.vertices(:, 1), struct.vertices(:, 2), struct.vertices(:, 3), varargin{:});
   end% if
end% if
axis tight
axis equal
hold on
if version('-release')>=12
   cameratoolbar('setmode', 'orbit')
else
   rotate3d on
end% if