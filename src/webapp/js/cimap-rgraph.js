function init() {
	Infovis.initLayout();
  var Log = {
	elem: $('log'),
	write: function(text) {
		this.elem.setHTML(text);
	}
  };
	
  //Create canvas instance with canvas id, fill and stroke colors.
  var canvas= new Canvas('infovis', '#ccddee', '#772277');
  var rgraph= new RGraph(canvas);
  var effectHash = {};
  
  rgraph.controller =  {
  	onBeforeCompute: function(node) {
		window.location.href='JSON?id=' + node.id;
	},

	onBegin: function(node) {
  		//Log.write("centering " + node.name + "...");
		my_node=node;
  		var _self = this;
  		var html = "<h4><a href=\"NodeDetails?nodeId=" + node.id+ "\" class=\"edge\">" + node.name + "</a></h4>";
  		html += "<ul>";
 		GraphUtil.eachAdjacency(rgraph.graph, node, function(child) {
 			if(child.data && child.data.length > 0) {
 				html += "<li><a href=\"NodeDetails?nodeId=" + child.id+ "\" class=\"edge\">" + child.name + " " + "</a><div class=\"relation\">(relation: " + _self.getName(node, child) + ")</div></li>";
 			}
 		});
 		html+= "</ul>";
		//html+="<hr width=\"100%\" /><form method=\"post\" action=\"Search\">Search: <p /><input type=\"text\" name=\"name\"></input><input type=\"hidden\" name=\"query\" value=\"search\"></input><br /><input type=\"submit\" name=\"submit\" value=\"search\"></form>";

		$('inner-details').set("html", html);
  	},
  	
  	getName: function(node1, node2) {
  		for(var i=0; i<node1.data.length; i++) {
  			var dataset = node1.data[i];
  			if(dataset.key == node2.name) return dataset.value;
  		}
  		
		for(var i=0; i<node2.data.length; i++) {
  			var dataset = node2.data[i];
  			if(dataset.key == node1.name) return dataset.value;
  		}
  	},
  	
  //Add a controller to assign the node's name to the created label.	
  	onCreateLabel: function(domElement, node) {
  		var d = $(domElement);
  		effectHash[node.id] = new Fx.Tween(d, 'opacity', {duration:300, transition:Fx.Transitions.linear, wait:false});
  		d.setOpacity(0.6);
  		d.set('html', node.name).addEvents({
  			'mouseenter': function() {
  				effectHash[node.id].start(0.6, 1);
  			},
  			
  			'mouseleave': function() {
  				effectHash[node.id].start(1, 0.6);
  			}
  		});
  	},
  	
  	//Take off previous width and height styles and
  	//add half of the *actual* label width to the left position
  	// That will center your label (do the math man). 
  	onPlaceLabel: function(domElement, node) {
		domElement.innerHTML = '';
		if(node._depth <= 1) {
			domElement.innerHTML = node.name;
			var left = parseInt(domElement.style.left);
			domElement.style.width = '';
			domElement.style.height = '';
			var w = domElement.offsetWidth;
			domElement.style.left = (left - w /2) + 'px';

		} 
	},
	
	onAfterCompute: function() {
		//Log.write("done");
	}
  	
  };
  
  //load graph from tree data.
  rgraph.loadTreeFromJSON(json);
  //compute positions
  rgraph.compute();
  //make first plot
  rgraph.plot();
  
  rgraph.controller.onBegin(GraphUtil.getNode(rgraph.graph, rgraph.root));
  rgraph.controller.onAfterCompute();
}