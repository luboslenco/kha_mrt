package;

import kha.Framebuffer;
import kha.Color;
import kha.Shaders;
import kha.graphics4.PipelineState;
import kha.graphics4.VertexStructure;
import kha.graphics4.VertexBuffer;
import kha.graphics4.IndexBuffer;
import kha.graphics4.VertexData;
import kha.graphics4.Usage;

class Empty {

	static var vertices:Array<Float> = [
	   -1.0, -1.0, 0.0,
	    1.0, -1.0, 0.0,
	    0.0,  1.0, 0.0
	];
	static var indices:Array<Int> = [
		0, 1, 2
	];

	var vertexBuffer:VertexBuffer;
	var indexBuffer:IndexBuffer;
	var pipeline:PipelineState;

	var target0:kha.Image;
	var target1:kha.Image;
	var target2:kha.Image;
	var target3:kha.Image;

	public function new() {
		
		var structure = new VertexStructure();
        structure.add("pos", VertexData.Float3);
        var structureLength = 3;
		pipeline = new PipelineState();
		pipeline.inputLayout = [structure];
		pipeline.fragmentShader = Shaders.simple_frag;
		pipeline.vertexShader = Shaders.simple_vert;
		pipeline.compile();

		vertexBuffer = new VertexBuffer(Std.int(vertices.length / 3), structure, Usage.StaticUsage);
		
		var vbData = vertexBuffer.lock();
		for (i in 0...vbData.length) {
			vbData.set(i, vertices[i]);
		}
		vertexBuffer.unlock();

		indexBuffer = new IndexBuffer(indices.length, Usage.StaticUsage);
		
		var iData = indexBuffer.lock();
		for (i in 0...iData.length) {
			iData[i] = indices[i];
		}
		indexBuffer.unlock();

		var hw = Std.int(kha.System.windowWidth() / 2);
		var hh = Std.int(kha.System.windowHeight() / 2);

		target0 = kha.Image.createRenderTarget(hw, hh);
		target1 = kha.Image.createRenderTarget(hw, hh);
		target2 = kha.Image.createRenderTarget(hw, hh);
		target3 = kha.Image.createRenderTarget(hw, hh);
    }

	public function render(frame:Framebuffer) {

		var g = target0.g4;
        g.begin([target1, target2, target3]);
		g.clear(Color.Black);
		g.setPipeline(pipeline);
		g.setVertexBuffer(vertexBuffer);
		g.setIndexBuffer(indexBuffer);
		g.drawIndexedVertices();
		g.end();

		var hw = kha.System.windowWidth() / 2;
		var hh = kha.System.windowHeight() / 2;

		frame.g2.begin();
		if (g.renderTargetsInvertedY()){
			frame.g2.drawScaledImage(target0, 0, hh, hw, -hh);
			frame.g2.drawScaledImage(target1, hw, hh, hw, -hh);
			frame.g2.drawScaledImage(target2, 0, hh * 2, hw, -hh);
			frame.g2.drawScaledImage(target3, hw, hh * 2, hw, -hh);
		}
		else {
			frame.g2.drawImage(target0, 0, 0);
			frame.g2.drawImage(target1, hw, 0);
			frame.g2.drawImage(target2, 0, hh);
			frame.g2.drawImage(target3, hw, hh);
		}
		frame.g2.end();
    }
}
