figure(1); clf;
plot(rand(1,5),'ButtonDownFcn',@lineCallback)

function lineCallback(src,~)
   src.Color = rand(1,3);
end
