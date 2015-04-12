/*
	this file is part of SplitBot
	SplitBot: an attempt to a better AI in 0ad - see http://code.google.com/p/split-bot/

	SplitBot is (c) 2011-2012 Alexandre Hoyau and is released under the GPL License:

	This program is free software; you can redistribute it and/or
	modify it under the terms of the GNU General Public License (GPL)
	as published by the Free Software Foundation; either version 2
	of the License, or (at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
	GNU General Public License for more details.
	
	To read the license please visit http://www.gnu.org/copyleft/gpl.html
*/
Engine.IncludeModule("common-api"); 
var $estr, js, $s, org, Main, $Main, BotAI, Std, IntIter, Reflect, $_, $e, $closure, document={}, window={}, onerror, Int, Dynamic, Float, Bool, Class, Enum, Void; 
org = {zeroad:{common_api:{BaseAI:BaseAI,EntityCollection:EntityCollection,Entity:Entity,EntityTemplate:EntityTemplate}}};function $extend(from, fields) {
	function Inherit() {} Inherit.prototype = from; var proto = new Inherit();
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
var BotAI = function(settings) {
	org.zeroad.common_api.BaseAI.call(this,settings);
};
BotAI.__name__ = true;
BotAI.__super__ = org.zeroad.common_api.BaseAI;
BotAI.prototype = $extend(org.zeroad.common_api.BaseAI.prototype,{
	OnUpdate: function(state) {
		org.zeroad.common_api.BaseAI.prototype.OnUpdate.call(this,state);
		this.state = state;
		org.zeroad.splitbot.helper.MapHelper.init(this);
		org.zeroad.splitbot.helper.Debug0AD.init(this);
		org.zeroad.splitbot.helper.EntityHelper.init(this);
		org.zeroad.splitbot.core.Statistic.update(this);
		if(this.agent1 == null) {
			this.agent1 = new org.zeroad.splitbot.agent.ChiefAgent(this,null);
			this.agent1.takeEntities(org.zeroad.splitbot.helper.EntityHelper.myEntities);
		}
		org.zeroad.splitbot.core.Sequencer.getInstance().onUpdate(this);
		org.zeroad.splitbot.helper.MapHelper.cleanup();
		org.zeroad.splitbot.helper.Debug0AD.cleanup();
		org.zeroad.splitbot.helper.EntityHelper.cleanup();
		this.state = null;
	}
});
var Main = function() { };
Main.__name__ = true;
Main.main = function() {
	Main.botAI = new BotAI(Main.settings);
};
Math.__name__ = true;
var Reflect = function() { };
Reflect.__name__ = true;
Reflect.hasField = function(o,field) {
	return Object.prototype.hasOwnProperty.call(o,field);
};
Reflect.field = function(o,field) {
	try {
		return o[field];
	} catch( e ) {
		return null;
	}
};
Reflect.callMethod = function(o,func,args) {
	return func.apply(o,args);
};
Reflect.fields = function(o) {
	var a = [];
	if(o != null) {
		var hasOwnProperty = Object.prototype.hasOwnProperty;
		for( var f in o ) {
		if(f != "__id__" && f != "hx__closures__" && hasOwnProperty.call(o,f)) a.push(f);
		}
	}
	return a;
};
Reflect.isFunction = function(f) {
	return typeof(f) == "function" && !(js.Boot.isClass(f) || js.Boot.isEnum(f));
};
Reflect.compareMethods = function(f1,f2) {
	if(f1 == f2) return true;
	if(!Reflect.isFunction(f1) || !Reflect.isFunction(f2)) return false;
	return f1.scope == f2.scope && f1.method == f2.method && f1.method != null;
};
var Std = function() { };
Std.__name__ = true;
Std.string = function(s) {
	return js.Boot.__string_rec(s,"");
};
var js = js || {};
js.Boot = function() { };
js.Boot.__name__ = true;
js.Boot.isClass = function(o) {
	return o.__name__;
};
js.Boot.isEnum = function(e) {
	return e.__ename__;
};
js.Boot.__string_rec = function(o,s) {
	if(o == null) return "null";
	if(s.length >= 5) return "<...>";
	var t = typeof(o);
	if(t == "function" && (js.Boot.isClass(o) || js.Boot.isEnum(o))) t = "object";
	switch(t) {
	case "object":
		if(o instanceof Array) {
			if(o.__enum__) {
				if(o.length == 2) return o[0];
				var str = o[0] + "(";
				s += "\t";
				var _g1 = 2;
				var _g = o.length;
				while(_g1 < _g) {
					var i = _g1++;
					if(i != 2) str += "," + js.Boot.__string_rec(o[i],s); else str += js.Boot.__string_rec(o[i],s);
				}
				return str + ")";
			}
			var l = o.length;
			var i1;
			var str1 = "[";
			s += "\t";
			var _g2 = 0;
			while(_g2 < l) {
				var i2 = _g2++;
				str1 += (i2 > 0?",":"") + js.Boot.__string_rec(o[i2],s);
			}
			str1 += "]";
			return str1;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e ) {
			return "???";
		}
		if(tostr != null && tostr != Object.toString) {
			var s2 = o.toString();
			if(s2 != "[object Object]") return s2;
		}
		var k = null;
		var str2 = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) {
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str2.length != 2) str2 += ", \n";
		str2 += s + k + " : " + js.Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str2 += "\n" + s + "}";
		return str2;
	case "function":
		return "<function>";
	case "string":
		return o;
	default:
		return String(o);
	}
};
var org = org || {};
if(!org.zeroad) org.zeroad = {};
if(!org.zeroad.common_api) org.zeroad.common_api = {};
org.zeroad.common_api.ResourceSupply = function(resourceSupplyType,resourceSupplySubType,resourceCount) {
	this.generic = resourceSupplyType;
	this.specific = resourceSupplySubType;
	this.count = resourceCount;
};
org.zeroad.common_api.ResourceSupply.__name__ = true;
org.zeroad.common_api.ResourceSupply.getRessourceArray = function(botAI) {
	return [new org.zeroad.common_api.ResourceSupply("food","",Reflect.field(botAI.playerData.resourceCounts,"food")),new org.zeroad.common_api.ResourceSupply("wood","",Reflect.field(botAI.playerData.resourceCounts,"wood")),new org.zeroad.common_api.ResourceSupply("stone","",Reflect.field(botAI.playerData.resourceCounts,"stone")),new org.zeroad.common_api.ResourceSupply("metal","",Reflect.field(botAI.playerData.resourceCounts,"metal"))];
};
org.zeroad.common_api.ResourceSupplyTypeValue = function() { };
org.zeroad.common_api.ResourceSupplyTypeValue.__name__ = true;
org.zeroad.common_api.Utils = function() {
};
org.zeroad.common_api.Utils.__name__ = true;
org.zeroad.common_api.Utils.VectorDistance = function(a,b) {
	var dx = a[0] - b[0];
	var dz = a[1] - b[1];
	return Math.sqrt(dx * dx + dz * dz);
};
org.zeroad.common_api.Utils.applyCiv = function(civ,templateName) {
	return civ + "_" + templateName;
};
org.zeroad.common_api.Utils.isInArray = function(array,element) {
	var idx = 0;
	while(idx < array.length && array[idx] != element) idx++;
	return idx < array.length;
};
if(!org.zeroad.splitbot) org.zeroad.splitbot = {};
if(!org.zeroad.splitbot.agent) org.zeroad.splitbot.agent = {};
org.zeroad.splitbot.agent.Agent = function(botAI,parentAgentUID) {
	this.agentUID = org.zeroad.splitbot.agent.Agent._nextId++;
	this.parentAgentUID = parentAgentUID;
};
org.zeroad.splitbot.agent.Agent.__name__ = true;
org.zeroad.splitbot.agent.Agent.prototype = {
	cleanup: function() {
	}
	,onUpdate: function(botAI) {
	}
	,isMyEntity: function(entitiy) {
		return entitiy.getMetadata("ENTITY_META_OWNER_ID") == Std.string(this.agentUID);
	}
	,isMyParentEntity: function(entitiy) {
		return this.parentAgentUID != null && entitiy.getMetadata("ENTITY_META_OWNER_ID") == Std.string(this.parentAgentUID);
	}
	,setAsMyEntity: function(entitiy) {
		entitiy.setMetadata("ENTITY_META_OWNER_ID",Std.string(this.agentUID));
	}
	,takeEntities: function(entities,ownerAgentUID,classesRequired,maxNumEntities) {
		if(maxNumEntities == null) maxNumEntities = -1;
		if(classesRequired == null) classesRequired = new Array();
		var me = this;
		var numEntities = 0;
		var myEntities = entities.filter(function(ent,str) {
			if((ownerAgentUID == null || ent.getMetadata("ENTITY_META_OWNER_ID") == null || ent.getMetadata("ENTITY_META_OWNER_ID") == ownerAgentUID) && ent.isOwn() && org.zeroad.splitbot.helper.EntityHelper.hasClasses(ent,classesRequired)) {
				if(maxNumEntities < 0 || numEntities++ < maxNumEntities) {
					me.setAsMyEntity(ent);
					return true;
				}
			}
			return false;
		});
		return myEntities;
	}
	,getCivicCenter: function() {
		var me = this;
		var civicCenterEntity = org.zeroad.splitbot.helper.EntityHelper.myBuildingStructures.filter(function(ent,str) {
			return (me.isMyEntity(ent) || me.isMyParentEntity(ent)) && ent.templateName() == org.zeroad.splitbot.helper.EntityHelper.TEMPLATE_STRUCTURE_CIVIC_CENTER;
		}).toEntityArray()[0];
		return civicCenterEntity;
	}
	,getMyEntities: function() {
		var me = this;
		return org.zeroad.splitbot.helper.EntityHelper.myEntities.filter(function(ent,str) {
			return me.isMyEntity(ent);
		});
	}
	,getBuilders: function(entities) {
		var me = this;
		return entities.filter(function(ent,str) {
			return me.isMyEntity(ent) && ent.buildableEntities() != null;
		});
	}
	,getWorkers: function() {
		var me = this;
		return org.zeroad.splitbot.helper.EntityHelper.myBuilderUnits.filter(function(ent,str) {
			return me.isMyEntity(ent) && ent.buildableEntities() != null;
		});
	}
	,getFondations: function() {
		var me = this;
		return org.zeroad.splitbot.helper.EntityHelper.myBuildingStructures.filter(function(ent,str) {
			return ent.isOwn() && ent.foundationProgress() != null;
		});
	}
	,getBuildings: function(allowedTemplateNames) {
		var me = this;
		if(org.zeroad.splitbot.helper.EntityHelper.myBuildingStructures.length <= 0) return org.zeroad.splitbot.helper.EntityHelper.myBuildingStructures;
		return org.zeroad.splitbot.helper.EntityHelper.myBuildingStructures.filter(function(ent,str) {
			return (me.isMyEntity(ent) && ent.trainableEntities() != null || me.isMyParentEntity(ent) && ent.templateName() == org.zeroad.splitbot.helper.EntityHelper.TEMPLATE_STRUCTURE_CIVIC_CENTER) && (allowedTemplateNames == null || org.zeroad.common_api.Utils.isInArray(allowedTemplateNames,ent.templateName()));
		});
	}
	,getResources: function(entities,type) {
		return entities.filter(function(ent,str) {
			var entType = ent.resourceSupplyType();
			if(entType != null && (type == null || entType.generic == type)) return true; else return false;
		});
	}
};
org.zeroad.splitbot.agent.AttackerAgent = function(botAI,parentAgentUID) {
	org.zeroad.splitbot.agent.Agent.call(this,botAI,parentAgentUID);
	org.zeroad.splitbot.core.Sequencer.getInstance().addTimer(this,$bind(this,this.attack),1,250);
};
org.zeroad.splitbot.agent.AttackerAgent.__name__ = true;
org.zeroad.splitbot.agent.AttackerAgent.__super__ = org.zeroad.splitbot.agent.Agent;
org.zeroad.splitbot.agent.AttackerAgent.prototype = $extend(org.zeroad.splitbot.agent.Agent.prototype,{
	cleanup: function() {
		org.zeroad.splitbot.agent.Agent.prototype.cleanup.call(this);
		org.zeroad.splitbot.core.Sequencer.getInstance().removeTimer(this,$bind(this,this.attack));
	}
	,attack: function(botAI) {
		var me = this;
		var attackers = this.getMyEntities();
		if(attackers == null || attackers.length <= 0) return;
		var troupsCenter = new org.zeroad.splitbot.core.Point(0,0);
		attackers.forEach(function(ent,str) {
			var point = org.zeroad.splitbot.core.Point.arrayPoint2Point(ent.position());
			troupsCenter.x += point.x;
			troupsCenter.y += point.y;
			return true;
		});
		troupsCenter.x = troupsCenter.x / attackers.length;
		troupsCenter.y = troupsCenter.y / attackers.length;
		var nearestOponentBuilding = null;
		var nearestOponentBuildingDistance = Math.POSITIVE_INFINITY;
		org.zeroad.splitbot.helper.EntityHelper.enemyEntities.forEach(function(ent1,str1) {
			var tmpDistance;
			if((tmpDistance = org.zeroad.common_api.Utils.VectorDistance(ent1.position(),troupsCenter.toArrayPoint())) < nearestOponentBuildingDistance) {
				nearestOponentBuildingDistance = tmpDistance;
				nearestOponentBuilding = ent1;
			}
			return false;
		});
		if(nearestOponentBuilding != null) {
			var targetPoint = org.zeroad.splitbot.core.Point.arrayPoint2Point(nearestOponentBuilding.position());
			attackers.move(targetPoint.x,targetPoint.y);
		} else org.zeroad.splitbot.helper.Debug0AD.error("Attack failed: impossible to find the nearest enemy building");
	}
});
org.zeroad.splitbot.agent.BuilderAgent = function(botAI,parentAgentUID) {
	org.zeroad.splitbot.agent.Agent.call(this,botAI,parentAgentUID);
	this.goodTemplateNames = org.zeroad.splitbot.agent.BuilderAgent.GOOD_TEMPLATE_NAMES;
};
org.zeroad.splitbot.agent.BuilderAgent.__name__ = true;
org.zeroad.splitbot.agent.BuilderAgent.__super__ = org.zeroad.splitbot.agent.Agent;
org.zeroad.splitbot.agent.BuilderAgent.prototype = $extend(org.zeroad.splitbot.agent.Agent.prototype,{
	setMetadataOnNewBuildings: function(entities) {
		var me = this;
		entities.forEach(function(ent,str) {
			if(ent.hasClass("Structure") && ent.isOwn() && ent.getMetadata("ENTITY_META_OWNER_ID") == null) {
				if(ent.foundationProgress() != null) me.setAsMyEntity(ent); else {
					me.onNewBuilding(ent);
					me.currentBuildingId == null;
				}
			}
			return false;
		});
	}
	,onUpdate: function(botAI) {
		org.zeroad.splitbot.agent.Agent.prototype.onUpdate.call(this,botAI);
		var units = this.getBuilders(botAI.entities);
		var foundations = this.getFondations();
		var closestFoundation = null;
		var closestFoundationDistance = Math.POSITIVE_INFINITY;
		if(units.length > 0 && foundations.length > 0) foundations.forEach(function(ent,str) {
			var dist = org.zeroad.common_api.Utils.VectorDistance(ent.position(),units.toEntityArray()[0].position());
			if(dist < closestFoundationDistance) {
				closestFoundation = ent;
				closestFoundationDistance = dist;
			}
			return false;
		});
		var me = this;
		if(closestFoundation != null) {
			this.currentBuildingProgress = closestFoundation.hitpoints();
			units.forEach(function(ent1,str1) {
				ent1.repair(closestFoundation);
				return false;
			});
			if(this.currentBuildingId == null || this.currentBuildingId != closestFoundation.id()) {
				this.currentBuildingId = closestFoundation.id();
				this.currentBuildingStartTurn = org.zeroad.splitbot.core.Sequencer.getInstance().turnNumber;
			} else if(org.zeroad.splitbot.core.Sequencer.getInstance().turnNumber - this.currentBuildingStartTurn > 200 && this.currentBuildingProgress == 1) closestFoundation.destroy();
		} else this.build(botAI,botAI.entities,botAI.playerData.civ);
	}
	,getBestTemplate: function(templatesNames,civ) {
		if(this.goodTemplateNames.length <= 0) return null;
		var idx;
		var probabilities = new Array();
		var goodTemplates = new Array();
		var _g1 = 0;
		var _g = templatesNames.length;
		while(_g1 < _g) {
			var idx1 = _g1++;
			if(org.zeroad.common_api.Utils.isInArray(this.goodTemplateNames,templatesNames[idx1])) goodTemplates.push(templatesNames[idx1]);
		}
		var _g11 = 0;
		var _g2 = goodTemplates.length;
		while(_g11 < _g2) {
			var idx2 = _g11++;
			probabilities.push(Math.round(100 / goodTemplates.length));
		}
		return org.zeroad.splitbot.core.Statistic.choose(goodTemplates,probabilities);
	}
	,build: function(botAI,entities,civ,templateName,position) {
		var me = this;
		var onlyFirstTime = false;
		var unitsEntityCollection = this.getBuilders(entities);
		var units;
		units = unitsEntityCollection.toEntityArray();
		if(units.length <= 0) return;
		var randomIndex = Math.round(Math.random() * (units.length - 1));
		var ent = units[randomIndex];
		if(ent.isIdle()) {
			if(templateName == null) templateName = me.getBestTemplate(ent.buildableEntities(),civ);
			if(templateName != null) {
				var entityTemplate = new org.zeroad.common_api.EntityTemplate(Reflect.field(botAI.templates,templateName));
				var templateSize = entityTemplate.obstructionRadius();
				var buildPosition;
				if(position != null) buildPosition = position; else buildPosition = me.getGoodPostionForbuilding(entities,templateSize,templateSize,civ);
				ent.construct(templateName,buildPosition.toArrayPoint()[0],buildPosition.toArrayPoint()[1],0.75 * Math.PI);
				unitsEntityCollection.move(buildPosition.toArrayPoint()[0],buildPosition.toArrayPoint()[1]);
			}
		}
		this.setMetadataOnNewBuildings(entities);
	}
	,getAngle: function(pointCenter,point) {
		return new org.zeroad.splitbot.core.Point(pointCenter.x - point.x,pointCenter.y - point.y).toPolarCoord().angle;
	}
	,getGoodPostionForbuilding: function(entities,width,height,civ) {
		var debugStr = width + ", " + height;
		var civCenter = this.getCivicCenter();
		if(civCenter != null) {
			if(this.lastGoodPosition == null || org.zeroad.splitbot.core.Statistic.choose([true,false],[10,90]) == true) this.lastGoodPosition = org.zeroad.splitbot.core.Point.arrayPoint2Point(civCenter.position());
			var securityMaxLoop = 0;
			var relativeCoord = org.zeroad.splitbot.core.Point.arrayPoint2Point(civCenter.position());
			var polarCoord = this.lastGoodPosition.toPolarCoord(relativeCoord.x,relativeCoord.y);
			var angle = 0;
			while(true) {
				this.lastGoodPosition.x += Math.round((Math.random() - .5) * (width + 20));
				this.lastGoodPosition.y += Math.round((Math.random() - .5) * (height + 20));
				if(!org.zeroad.splitbot.helper.MapHelper.isObstructed(this.lastGoodPosition,width + 20,height + 20,["building-land","foundationObstruction","pathfinderObstruction","default","unrestricted"])) {
					org.zeroad.splitbot.helper.Debug0AD.log("GOOD POSITION TO BUILD " + this.lastGoodPosition.x + "," + this.lastGoodPosition.y + "- " + polarCoord.angle);
					return this.lastGoodPosition;
				}
				if(securityMaxLoop++ > 100000) break;
			}
			org.zeroad.splitbot.helper.Debug0AD.error("Could not find a place to build");
		}
		org.zeroad.splitbot.helper.Debug0AD.log("COULD NOT FIND POSITION TO BUILD ");
		return new org.zeroad.splitbot.core.Point(-10000,-10000);
	}
});
org.zeroad.splitbot.agent.ChiefAgent = function(botAI,parentAgentUID) {
	org.zeroad.splitbot.agent.Agent.call(this,botAI,parentAgentUID);
	if(org.zeroad.splitbot.agent.ChiefAgent.chiefAgentsArray == null) org.zeroad.splitbot.agent.ChiefAgent.chiefAgentsArray = new Array();
	org.zeroad.splitbot.agent.ChiefAgent.chiefAgentsArray.push(this);
	org.zeroad.splitbot.agent.ChiefAgent.chiefAgentNumber = org.zeroad.splitbot.agent.ChiefAgent.chiefAgentsArray.length - 1;
	this._buildingCivCenterPending = 0;
	this._hasSplit = false;
	this.attackerAgentsArray = new Array();
	this._attackPending = 0;
	this._attackMode = false;
	var randomSeed = Math.round(new Date().getMinutes() / 10);
	org.zeroad.splitbot.core.Sequencer.getInstance().addTimer(this,$bind(this,this.onUpdate),randomSeed,2);
	org.zeroad.splitbot.core.Sequencer.getInstance().addTimer(this,$bind(this,this.saySomething),randomSeed * 15,100);
	this.name = "Chief #" + org.zeroad.splitbot.agent.ChiefAgent.chiefAgentNumber;
};
org.zeroad.splitbot.agent.ChiefAgent.__name__ = true;
org.zeroad.splitbot.agent.ChiefAgent.__super__ = org.zeroad.splitbot.agent.Agent;
org.zeroad.splitbot.agent.ChiefAgent.prototype = $extend(org.zeroad.splitbot.agent.Agent.prototype,{
	saySomething: function(botAI) {
		botAI.chat("--------------------------Agent " + this.name + " speeking. I have " + (this.builderAgent1.getBuilders(org.zeroad.splitbot.helper.EntityHelper.myEntities).length + this.builderAgent2.getBuilders(org.zeroad.splitbot.helper.EntityHelper.myEntities).length) + " builders, " + this.workerAgent.getWorkers().length + " workers, " + this.machinaSexualAgent.getBuildings().length + " buildings, " + "resources: [" + org.zeroad.splitbot.core.Statistic.foodCount + ", " + org.zeroad.splitbot.core.Statistic.woodCount + ", " + org.zeroad.splitbot.core.Statistic.stoneCount + ", " + org.zeroad.splitbot.core.Statistic.metalCount + "]");
		var enemiesArray = new Array();
		var idx;
		if(botAI.state != null) {
			var _g1 = 0;
			var _g = botAI.state.players.length;
			while(_g1 < _g) {
				var idx1 = _g1++;
				if(botAI.playerData.isEnemy[idx1]) enemiesArray.push(botAI.state.players[idx1]);
			}
			var enemyPlayer = org.zeroad.splitbot.core.Statistic.choose(enemiesArray);
			var enemyName = enemyPlayer.name;
			botAI.chat("Hey " + enemyName + " ! SplitBot is after you... Eu sunt cu ochii pe tine...");
		}
	}
	,onUpdate: function(botAI) {
		org.zeroad.splitbot.agent.Agent.prototype.onUpdate.call(this,botAI);
		var entities = this.getMyEntities();
		if(this.machinaSexualAgent == null) {
			botAI.chat("INIT " + this.name + " with " + entities.length + " entities");
			this.builderAgent1 = new org.zeroad.splitbot.agent.BuilderAgent(botAI,this.agentUID);
			this.builderAgent2 = new org.zeroad.splitbot.agent.BuilderAgent(botAI,this.agentUID);
			this.defenderAgent = new org.zeroad.splitbot.agent.DefenderAgent(botAI,this.agentUID);
			this.machinaSexualAgent = new org.zeroad.splitbot.agent.MachinaSexualAgent(botAI,this.agentUID);
			this.workerAgent = new org.zeroad.splitbot.agent.WorkerAgent(botAI,this.agentUID);
			var workers = this.workerAgent.takeEntities(this.getBuilders(entities),this.agentUID,null,4);
			this.builderAgent1.takeEntities(this.getWorkers(),this.agentUID);
			this.machinaSexualAgent.takeEntities(this.getBuildings(),this.agentUID);
			var keepCivCenter = this.machinaSexualAgent.getCivicCenter();
			if(keepCivCenter != null) this.setAsMyEntity(keepCivCenter);
			this.builderAgent1.onNewBuilding = $bind(this,this.onNewBuilding);
			this.builderAgent2.onNewBuilding = $bind(this,this.onNewBuilding);
			this.machinaSexualAgent.onNewUnitStart = $bind(this,this.onNewUnitStart);
			this.defenderAgent.onAttackStart = $bind(this,this.onAttackStart);
			this.defenderAgent.onAttackStop = $bind(this,this.onAttackStop);
		} else {
			if(this.getCivicCenter() == null) {
				var underConstructionCC = this.getCCFondation();
				if(underConstructionCC == null) {
					var availableCC = this.getAvailableCC();
					if(availableCC != null) {
						org.zeroad.splitbot.helper.Debug0AD.log("ChiefAgent, YEAH, I GOT A CC NOW !!!");
						this.setAsMyEntity(availableCC);
					} else {
						this._buildingCivCenterPending = 100;
						var fatherCC = org.zeroad.splitbot.agent.ChiefAgent.chiefAgentsArray[org.zeroad.splitbot.agent.ChiefAgent.chiefAgentNumber - 1].getCivicCenter();
						if(fatherCC == null) {
							org.zeroad.splitbot.helper.Debug0AD.log("NO CC on the parent !!! son: " + org.zeroad.splitbot.agent.ChiefAgent.chiefAgentNumber + " - " + org.zeroad.splitbot.agent.ChiefAgent.chiefAgentsArray[org.zeroad.splitbot.agent.ChiefAgent.chiefAgentNumber].name + " ----------- father: " + org.zeroad.splitbot.agent.ChiefAgent.chiefAgentsArray[org.zeroad.splitbot.agent.ChiefAgent.chiefAgentNumber - 1].name + " - " + Std.string(org.zeroad.splitbot.agent.ChiefAgent.chiefAgentsArray[org.zeroad.splitbot.agent.ChiefAgent.chiefAgentNumber - 1].getCivicCenter()));
							return;
						}
						var buildPosition = this.getGoodPostionForbuildingCC(fatherCC);
						var myEntities = this.workerAgent.getMyEntities();
						myEntities.toEntityArray()[0].construct(org.zeroad.splitbot.helper.EntityHelper.TEMPLATE_STRUCTURE_CIVIC_CENTER,buildPosition.toArrayPoint()[0],buildPosition.toArrayPoint()[1],0.75 * Math.PI);
						myEntities.move(buildPosition.toArrayPoint()[0],buildPosition.toArrayPoint()[1]);
					}
				} else org.zeroad.splitbot.helper.Debug0AD.log("--------------SPLIT !!! Construction of CC has started");
				return;
			}
			if(this._hasSplit == false && org.zeroad.splitbot.agent.ChiefAgent.chiefAgentNumber >= org.zeroad.splitbot.agent.ChiefAgent.chiefAgentsArray.length - 1 && this.builderAgent2.getMyEntities().length >= 5) {
				this._hasSplit = true;
				var sonChiefAgent = new org.zeroad.splitbot.agent.ChiefAgent(botAI,null);
				var givenBuilders = sonChiefAgent.takeEntities(this.builderAgent2.getMyEntities());
				org.zeroad.splitbot.helper.Debug0AD.log("SPLIT !!! total of chiefs=" + org.zeroad.splitbot.agent.ChiefAgent.chiefAgentsArray.length + "--------------------" + sonChiefAgent.name + " has " + givenBuilders.length + " builders and " + this.name + " has " + this.builderAgent2.getMyEntities().length);
			}
			if((this._attackMode || botAI.playerData.popCount >= 170) && this._attackPending-- <= 0) {
				if(botAI.playerData.popCount > 50) this._attackMode = true; else this._attackMode = false;
				this._attackPending = 50;
				this.attack(botAI);
			}
			this.builderAgent1.goodTemplateNames = org.zeroad.splitbot.agent.BuilderAgent.GOOD_TEMPLATE_NAMES;
			var barracks = this.machinaSexualAgent.getBuildings([org.zeroad.splitbot.helper.EntityHelper.TEMPLATE_STRUCTURE_BARRACKS]);
			var fields = org.zeroad.splitbot.helper.EntityHelper.myEntities.filter(function(ent,str) {
				return ent.templateName() == org.zeroad.splitbot.helper.EntityHelper.TEMPLATE_STRUCTURE_FIELD;
			});
			if(botAI.playerData.popCount > 50) {
				this.builderAgent1.goodTemplateNames.push(org.zeroad.splitbot.helper.EntityHelper.TEMPLATE_STRUCTURE_SCOUT_TOWER);
				var templateNameAttack;
				var _g = 0;
				var _g1 = org.zeroad.splitbot.helper.EntityHelper.TEMPLATE_STRUCTURE_ATTACK_ARRAY;
				while(_g < _g1.length) {
					var templateNameAttack1 = _g1[_g];
					++_g;
					if(this.machinaSexualAgent.getBuildings([templateNameAttack1]).length <= 0) this.builderAgent1.goodTemplateNames.push(templateNameAttack1);
				}
			}
			if(botAI.playerData.popCount < botAI.playerData.popLimit * 0.90 || botAI.playerData.popLimit >= 200) {
				if(this.machinaSexualAgent.getBuildings().length > 5) {
				}
				if(fields.length < 3) this.builderAgent1.goodTemplateNames.push(org.zeroad.splitbot.helper.EntityHelper.TEMPLATE_STRUCTURE_FIELD);
				if(barracks.length < 6) {
					this.builderAgent1.goodTemplateNames = this.builderAgent1.goodTemplateNames.concat([org.zeroad.splitbot.helper.EntityHelper.TEMPLATE_STRUCTURE_BARRACKS]);
					if(fields.length < 2) this.builderAgent1.goodTemplateNames.push(org.zeroad.splitbot.helper.EntityHelper.TEMPLATE_STRUCTURE_FIELD);
				} else {
				}
			} else this.builderAgent1.goodTemplateNames = this.builderAgent1.goodTemplateNames.concat([org.zeroad.splitbot.helper.EntityHelper.TEMPLATE_STRUCTURE_HOUSE,org.zeroad.splitbot.helper.EntityHelper.TEMPLATE_STRUCTURE_HOUSE,org.zeroad.splitbot.helper.EntityHelper.TEMPLATE_STRUCTURE_HOUSE]);
			this.builderAgent2.goodTemplateNames = this.builderAgent1.goodTemplateNames;
			this.machinaSexualAgent.badTemplateNames = org.zeroad.splitbot.agent.MachinaSexualAgent.BAD_TEMPLATE_NAMES;
			var women = this.workerAgent.getWorkers().filter(function(ent1,str1) {
				return ent1.templateName() == org.zeroad.splitbot.helper.EntityHelper.UNIT_SUPPORT_FEMALE_CITIZEN;
			});
			if(women.length > org.zeroad.splitbot.core.Statistic.peopleNumber / 10 && women.length > 50) this.machinaSexualAgent.badTemplateNames.push(org.zeroad.splitbot.helper.EntityHelper.UNIT_SUPPORT_FEMALE_CITIZEN);
			this.builderAgent1.onUpdate(botAI);
			this.builderAgent2.onUpdate(botAI);
			this.machinaSexualAgent.onUpdate(botAI);
			this.workerAgent.onUpdate(botAI);
		}
	}
	,getAvailableCC: function() {
		var me = this;
		return org.zeroad.splitbot.helper.EntityHelper.myEntities.filter(function(ent,str) {
			return ent.getMetadata("ENTITY_META_OWNER_ID") == null && ent.templateName() == org.zeroad.splitbot.helper.EntityHelper.TEMPLATE_STRUCTURE_CIVIC_CENTER;
		}).toEntityArray()[0];
	}
	,getCCFondation: function() {
		var me = this;
		return this.getFondations().filter(function(ent,str) {
			return ent.templateName() == "foundation|" + org.zeroad.splitbot.helper.EntityHelper.TEMPLATE_STRUCTURE_CIVIC_CENTER;
		}).toEntityArray()[0];
	}
	,getGoodPostionForbuildingCC: function(civCenter) {
		var templateSize = civCenter.obstructionRadius();
		var securityMaxLoop = 0;
		var positionCC = org.zeroad.splitbot.core.Point.arrayPoint2Point(civCenter.position());
		var mapCenterX = org.zeroad.splitbot.helper.MapHelper.passabilityMap.width * 4 / 2;
		var mapCenterY = org.zeroad.splitbot.helper.MapHelper.passabilityMap.height * 4 / 2;
		var polarCoordOfCC = new org.zeroad.splitbot.core.Point(positionCC.x - mapCenterX,positionCC.y - mapCenterY).toPolarCoord();
		while(true) {
			var newAngle = polarCoordOfCC.angle + (Math.random() - .5) * Math.PI;
			var newPoint = new org.zeroad.splitbot.core.PolarCoord(polarCoordOfCC.distance,newAngle).toPoint();
			newPoint.x += mapCenterX;
			newPoint.y += mapCenterY;
			newPoint.x = Math.round(newPoint.x);
			newPoint.y = Math.round(newPoint.y);
			if(!org.zeroad.splitbot.helper.MapHelper.isObstructed(newPoint,templateSize,templateSize,["building-land","foundationObstruction","pathfinderObstruction","default","unrestricted"])) return newPoint;
			if(securityMaxLoop++ > 100000) break;
		}
		org.zeroad.splitbot.helper.Debug0AD.error("Could not find a place to build the civic center for " + this.name);
		return new org.zeroad.splitbot.core.Point(-1,-1);
	}
	,attack: function(botAI) {
		var attackerAgent = new org.zeroad.splitbot.agent.AttackerAgent(botAI,this.agentUID);
		var people = org.zeroad.splitbot.helper.EntityHelper.myPeopleUnits;
		attackerAgent.takeEntities(org.zeroad.splitbot.helper.EntityHelper.myPeopleUnits,this.agentUID);
		var maxAttackers = 15;
		var attackers = people.filter(function(ent,str) {
			if(ent.templateName() != org.zeroad.splitbot.helper.EntityHelper.UNIT_SUPPORT_FEMALE_CITIZEN) return true;
			return false;
		});
		attackerAgent.takeEntities(attackers,this.workerAgent.agentUID,null,maxAttackers);
		var machines = attackerAgent.takeEntities(org.zeroad.splitbot.helper.EntityHelper.myEntities,this.agentUID,["Mechanical"],maxAttackers);
		this.attackerAgentsArray.push(attackerAgent);
		if(attackerAgent.getMyEntities().length <= 5) {
			this._attackMode = false;
			this._attackPending = 0;
		}
		org.zeroad.splitbot.helper.Debug0AD.log("One more attacker agent, with " + attackerAgent.getMyEntities().length + ", that makes " + this.attackerAgentsArray.length + " attacker agents ");
		this.cleanupAttackerAgents();
	}
	,cleanupAttackerAgents: function() {
		var attackersToRemove = new Array();
		var idx;
		var _g1 = 0;
		var _g = this.attackerAgentsArray.length;
		while(_g1 < _g) {
			var idx1 = _g1++;
			if(this.attackerAgentsArray[idx1].getMyEntities().length <= 0) attackersToRemove.unshift(idx1);
		}
		var _g11 = 0;
		var _g2 = attackersToRemove.length;
		while(_g11 < _g2) {
			var idx2 = _g11++;
			var removedAgent = this.attackerAgentsArray.splice(attackersToRemove[idx2],1)[0];
			removedAgent.cleanup();
		}
	}
	,onAttackStart: function() {
		org.zeroad.splitbot.helper.Debug0AD.log("onAttackStart ----------------------------------------------------------");
		this._attackPending = 50;
		this._attackMode = true;
	}
	,onAttackStop: function() {
		org.zeroad.splitbot.helper.Debug0AD.log("onAttackStop ----------------------------------------------------------");
	}
	,onNewBuilding: function(building) {
		if(building.templateName() == org.zeroad.splitbot.helper.EntityHelper.TEMPLATE_STRUCTURE_CIVIC_CENTER) return;
		this.machinaSexualAgent.setAsMyEntity(building);
	}
	,onNewUnitStart: function(entity,templateName) {
		if(entity.templateName() == org.zeroad.splitbot.helper.EntityHelper.TEMPLATE_STRUCTURE_FORTRESS) return this; else {
			var choicesArray = [];
			choicesArray.push(this.workerAgent);
			if(this.builderAgent1.getWorkers().length < 5) choicesArray.push(this.builderAgent1); else if(this.builderAgent2.getWorkers().length < 5) choicesArray.push(this.builderAgent2);
			return org.zeroad.splitbot.core.Statistic.choose(choicesArray);
		}
	}
});
org.zeroad.splitbot.agent.DefenderAgent = function(botAI,parentAgentUID) {
	org.zeroad.splitbot.agent.Agent.call(this,botAI,parentAgentUID);
	this._enemyPresenceTime = 0;
	this.isUnderAttack = false;
	org.zeroad.splitbot.core.Sequencer.getInstance().addTimer(this,$bind(this,this.defend),1,50);
};
org.zeroad.splitbot.agent.DefenderAgent.__name__ = true;
org.zeroad.splitbot.agent.DefenderAgent.__super__ = org.zeroad.splitbot.agent.Agent;
org.zeroad.splitbot.agent.DefenderAgent.prototype = $extend(org.zeroad.splitbot.agent.Agent.prototype,{
	defend: function(botAI) {
		var nearestOponentEntity = null;
		var nearestOponentEntityDistance = 160;
		var civCenter = this.getCivicCenter();
		if(civCenter != null) org.zeroad.splitbot.helper.EntityHelper.enemyEntities.forEach(function(ent,str) {
			var tmpDistance;
			if((tmpDistance = org.zeroad.common_api.Utils.VectorDistance(ent.position(),civCenter.position())) < nearestOponentEntityDistance) {
				nearestOponentEntityDistance = tmpDistance;
				nearestOponentEntity = ent;
			}
			return false;
		});
		if(nearestOponentEntity != null) {
			if(this._enemyPresenceTime++ > 1) {
				if(this.isUnderAttack == false) {
					this.isUnderAttack = true;
					if(this.onAttackStart != null) this.onAttackStart();
				}
			}
		} else {
			if(this.isUnderAttack == true) {
				this.isUnderAttack = false;
				if(this.onAttackStop != null) this.onAttackStop();
			}
			this._enemyPresenceTime = 0;
		}
	}
});
if(!org.zeroad.splitbot.helper) org.zeroad.splitbot.helper = {};
org.zeroad.splitbot.helper.EntityHelper = function() {
};
org.zeroad.splitbot.helper.EntityHelper.__name__ = true;
org.zeroad.splitbot.helper.EntityHelper.init = function(botAI) {
	org.zeroad.splitbot.helper.EntityHelper.TEMPLATE_STRUCTURE_CIVIC_CENTER = "structures/" + org.zeroad.common_api.Utils.applyCiv(botAI.playerData.civ,"civil_centre");
	org.zeroad.splitbot.helper.EntityHelper.TEMPLATE_STRUCTURE_HOUSE = "structures/" + org.zeroad.common_api.Utils.applyCiv(botAI.playerData.civ,"house");
	org.zeroad.splitbot.helper.EntityHelper.TEMPLATE_STRUCTURE_FIELD = "structures/" + org.zeroad.common_api.Utils.applyCiv(botAI.playerData.civ,"field");
	org.zeroad.splitbot.helper.EntityHelper.TEMPLATE_STRUCTURE_FORTRESS = "structures/" + org.zeroad.common_api.Utils.applyCiv(botAI.playerData.civ,"fortress");
	org.zeroad.splitbot.helper.EntityHelper.TEMPLATE_STRUCTURE_SCOUT_TOWER = "structures/" + org.zeroad.common_api.Utils.applyCiv(botAI.playerData.civ,"scout_tower");
	org.zeroad.splitbot.helper.EntityHelper.TEMPLATE_STRUCTURE_WALL = "structures/" + org.zeroad.common_api.Utils.applyCiv(botAI.playerData.civ,"wall");
	org.zeroad.splitbot.helper.EntityHelper.TEMPLATE_STRUCTURE_WALL_TOWER = "structures/" + org.zeroad.common_api.Utils.applyCiv(botAI.playerData.civ,"wall_tower");
	org.zeroad.splitbot.helper.EntityHelper.TEMPLATE_STRUCTURE_BARRACKS = "structures/" + org.zeroad.common_api.Utils.applyCiv(botAI.playerData.civ,"barracks");
	org.zeroad.splitbot.helper.EntityHelper.UNIT_SUPPORT_FEMALE_CITIZEN = "units/" + org.zeroad.common_api.Utils.applyCiv(botAI.playerData.civ,"support_female_citizen");
	org.zeroad.splitbot.helper.EntityHelper.UNIT_CAVALRY_JAVELINIST = "units/" + org.zeroad.common_api.Utils.applyCiv(botAI.playerData.civ,"cavalry_javelinist_b");
	org.zeroad.splitbot.helper.EntityHelper.UNIT_CAVALRY_SPEARMAN = "units/" + org.zeroad.common_api.Utils.applyCiv(botAI.playerData.civ,"cavalry_spearman_b");
	org.zeroad.splitbot.helper.EntityHelper.UNIT_CAVALRY_SWORDSMAN = "units/" + org.zeroad.common_api.Utils.applyCiv(botAI.playerData.civ,"cavalry_swordsman_b");
	org.zeroad.splitbot.helper.EntityHelper.UNIT_CHAMPION_CAVALRY_BRIT = "units/" + org.zeroad.common_api.Utils.applyCiv(botAI.playerData.civ,"champion_cavalry_brit");
	org.zeroad.splitbot.helper.EntityHelper.UNIT_CHAMPION_CAVALRY_GAUL = "units/" + org.zeroad.common_api.Utils.applyCiv(botAI.playerData.civ,"champion_cavalry_gaul");
	var _g = botAI.playerData.civ;
	switch(_g) {
	case "hele":
		org.zeroad.splitbot.helper.EntityHelper.TEMPLATE_STRUCTURE_ATTACK_ARRAY = ["structures/hele_tholos","structures/hele_fortress","structures/hele_gymnasion"];
		break;
	case "celt":
		org.zeroad.splitbot.helper.EntityHelper.TEMPLATE_STRUCTURE_ATTACK_ARRAY = ["structures/celt_fortress_g","structures/celt_fortress_b","structures/celt_kennel"];
		break;
	case "iber":
		org.zeroad.splitbot.helper.EntityHelper.TEMPLATE_STRUCTURE_ATTACK_ARRAY = ["structures/iber_fortress"];
		break;
	case "cart":
		org.zeroad.splitbot.helper.EntityHelper.TEMPLATE_STRUCTURE_ATTACK_ARRAY = ["structures/cart_fortress"];
		break;
	}
	org.zeroad.splitbot.helper.EntityHelper.enemyEntities = botAI.entities.filter(function(ent,str) {
		return !ent.isOwn() && ent.isEnemy() && ent.owner() > 0 && !ent.isFriendly() && ent.civ() != "gaia";
	});
	org.zeroad.splitbot.helper.EntityHelper.myEntities = botAI.entities.filter(function(ent1,str1) {
		return ent1.isOwn();
	});
	org.zeroad.splitbot.helper.EntityHelper.myPeopleUnits = org.zeroad.splitbot.helper.EntityHelper.myEntities.filter(function(ent2,str2) {
		return ent2.isHealable();
	});
	org.zeroad.splitbot.helper.EntityHelper.myBuilderUnits = org.zeroad.splitbot.helper.EntityHelper.myPeopleUnits.filter(function(ent3,str3) {
		return ent3.buildableEntities() != null;
	});
	org.zeroad.splitbot.helper.EntityHelper.myBuildingStructures = org.zeroad.splitbot.helper.EntityHelper.myEntities.filter(function(ent4,str4) {
		return ent4.trainableEntities() != null || ent4.foundationProgress() != null;
	});
};
org.zeroad.splitbot.helper.EntityHelper.cleanup = function() {
	org.zeroad.splitbot.helper.EntityHelper.enemyEntities = null;
	org.zeroad.splitbot.helper.EntityHelper.myEntities = null;
	org.zeroad.splitbot.helper.EntityHelper.myPeopleUnits = null;
	org.zeroad.splitbot.helper.EntityHelper.myBuilderUnits = null;
	org.zeroad.splitbot.helper.EntityHelper.myBuildingStructures = null;
};
org.zeroad.splitbot.helper.EntityHelper.hasClasses = function(entity,requiredClasses) {
	var idx;
	var _g1 = 0;
	var _g = requiredClasses.length;
	while(_g1 < _g) {
		var idx1 = _g1++;
		if(entity.hasClass(requiredClasses[idx1]) == false) return false;
	}
	return true;
};
org.zeroad.splitbot.helper.EntityHelper.hasOneOfTheClasses = function(entity,classesAllowed) {
	var idx;
	var _g1 = 0;
	var _g = classesAllowed.length;
	while(_g1 < _g) {
		var idx1 = _g1++;
		if(entity.hasClass(classesAllowed[idx1]) == true) return true;
	}
	return false;
};
org.zeroad.splitbot.agent.MachinaSexualAgent = function(botAI,parentAgentUID) {
	org.zeroad.splitbot.agent.Agent.call(this,botAI,parentAgentUID);
	this.badTemplateNames = org.zeroad.splitbot.agent.MachinaSexualAgent.BAD_TEMPLATE_NAMES;
};
org.zeroad.splitbot.agent.MachinaSexualAgent.__name__ = true;
org.zeroad.splitbot.agent.MachinaSexualAgent.__super__ = org.zeroad.splitbot.agent.Agent;
org.zeroad.splitbot.agent.MachinaSexualAgent.prototype = $extend(org.zeroad.splitbot.agent.Agent.prototype,{
	getBestTemplate: function(templatesNames) {
		var idx;
		var goodTemplateNames = new Array();
		var probabilities = new Array();
		var _g1 = 0;
		var _g = templatesNames.length;
		while(_g1 < _g) {
			var idx1 = _g1++;
			if(!org.zeroad.common_api.Utils.isInArray(this.badTemplateNames,templatesNames[idx1])) {
				goodTemplateNames.push(templatesNames[idx1]);
				probabilities.push(Math.round(100 / templatesNames.length));
			}
		}
		return org.zeroad.splitbot.core.Statistic.choose(goodTemplateNames,probabilities);
	}
	,onUpdate: function(botAI) {
		org.zeroad.splitbot.agent.Agent.prototype.onUpdate.call(this,botAI);
		this.build(this.getBuildings(),botAI.playerData.civ);
	}
	,build: function(buildings,civ,templateName,position) {
		var me = this;
		var onlyFirstTime = false;
		var debugString = "";
		debugString += "build ";
		buildings.forEach(function(ent,str) {
			if(ent.trainingQueue() != null && ent.trainingQueue().length == 0) {
				if(onlyFirstTime == false) {
					if(templateName == null) templateName = me.getBestTemplate(ent.trainableEntities());
					if(templateName != null) {
						ent.train(templateName,1,{ ENTITY_META_OWNER_ID : Std.string(me.onNewUnitStart(ent,templateName).agentUID)});
						onlyFirstTime = true;
					}
				}
			} else {
			}
			return true;
		});
	}
});
org.zeroad.splitbot.agent.WorkerAgent = function(botAI,parentAgentUID) {
	org.zeroad.splitbot.agent.Agent.call(this,botAI,parentAgentUID);
};
org.zeroad.splitbot.agent.WorkerAgent.__name__ = true;
org.zeroad.splitbot.agent.WorkerAgent.__super__ = org.zeroad.splitbot.agent.Agent;
org.zeroad.splitbot.agent.WorkerAgent.prototype = $extend(org.zeroad.splitbot.agent.Agent.prototype,{
	onUpdate: function(botAI) {
		org.zeroad.splitbot.agent.Agent.prototype.onUpdate.call(this,botAI);
		var entities = botAI.entities;
		this.work(botAI.entities,botAI.playerData.civ,org.zeroad.common_api.ResourceSupply.getRessourceArray(botAI));
	}
	,getBestResourceTemplate: function(resourcesArray) {
		resourcesArray[2].count *= 2;
		resourcesArray[3].count *= 2;
		resourcesArray.sort(function(obj1,obj2) {
			return obj1.count - obj2.count;
		});
		return resourcesArray[0].generic;
	}
	,work: function(entities,civ,resourcesArray) {
		var units;
		units = this.getWorkers();
		this.gatherIdle(entities,units,this.getBestResourceTemplate(resourcesArray));
	}
	,gatherIdle: function(entities,builders,resourceTemplateName) {
		var me = this;
		var resources = this.getResources(entities,resourceTemplateName).toEntityArray();
		builders.forEach(function(ent,str) {
			if(ent.isIdle()) {
				var targetEntity;
				resources.sort(function(e1,e2) {
					return Math.round(org.zeroad.common_api.Utils.VectorDistance(ent.position(),e1.position()) - org.zeroad.common_api.Utils.VectorDistance(ent.position(),e2.position()));
				});
				targetEntity = resources[0];
				ent.gather(targetEntity);
				var dist = org.zeroad.common_api.Utils.VectorDistance(targetEntity.position(),ent.position());
				if(dist > 200) org.zeroad.splitbot.helper.Debug0AD.log("WorkerAgent - work is very far from home!! :( " + dist);
			}
			return true;
		});
	}
});
if(!org.zeroad.splitbot.core) org.zeroad.splitbot.core = {};
org.zeroad.splitbot.core.Point = function(x,y) {
	this.x = x;
	this.y = y;
};
org.zeroad.splitbot.core.Point.__name__ = true;
org.zeroad.splitbot.core.Point.arrayPoint2Point = function(ap) {
	return new org.zeroad.splitbot.core.Point(ap[0],ap[1]);
};
org.zeroad.splitbot.core.Point.prototype = {
	toArrayPoint: function() {
		return [this.x,this.y,0];
	}
	,toPolarCoord: function(xOffset,yOffset,angleOffset) {
		if(angleOffset == null) angleOffset = 0;
		if(yOffset == null) yOffset = 0;
		if(xOffset == null) xOffset = 0;
		var distance = Math.sqrt(Math.pow(this.x - xOffset,2) + Math.pow(this.y - yOffset,2));
		var angle = angleOffset;
		if(distance != 0) angle += Math.acos((this.x - xOffset) / distance);
		return new org.zeroad.splitbot.core.PolarCoord(distance,angle % (2 * Math.PI));
	}
};
org.zeroad.splitbot.core.PolarCoord = function(distance,angle) {
	this.distance = distance;
	this.angle = angle % (2 * Math.PI);
};
org.zeroad.splitbot.core.PolarCoord.__name__ = true;
org.zeroad.splitbot.core.PolarCoord.prototype = {
	toPoint: function(xOffset,yOffset,angleOffset) {
		if(angleOffset == null) angleOffset = 0;
		if(yOffset == null) yOffset = 0;
		if(xOffset == null) xOffset = 0;
		var correctedAngle = this.angle - angleOffset;
		return new org.zeroad.splitbot.core.Point(this.distance * Math.cos(correctedAngle) + xOffset,this.distance * Math.sin(correctedAngle) + yOffset);
	}
};
org.zeroad.splitbot.core.Sequencer = function() {
	this._timerArray = new Array();
	this._sequenceArray = new Array();
	this._isPlayingSequence = false;
	this.turnNumber = 0;
};
org.zeroad.splitbot.core.Sequencer.__name__ = true;
org.zeroad.splitbot.core.Sequencer.getInstance = function() {
	if(org.zeroad.splitbot.core.Sequencer._instance == null) org.zeroad.splitbot.core.Sequencer._instance = new org.zeroad.splitbot.core.Sequencer();
	return org.zeroad.splitbot.core.Sequencer._instance;
};
org.zeroad.splitbot.core.Sequencer.prototype = {
	onUpdate: function(botAi) {
		this.turnNumber++;
		this._checkTimers(botAi);
		this._checkSequences(botAi);
	}
	,_checkSequences: function(botAi) {
		if(this._sequenceArray.length > 0) {
			if(this._sequenceArray[0].started == false) {
				this._isPlayingSequence = true;
				this._sequenceArray[0].started = true;
				Reflect.callMethod(this._sequenceArray[0].callerObject,this._sequenceArray[0].callbackFunc,[botAi]);
			}
		} else this._isPlayingSequence = false;
	}
	,_checkTimers: function(botAi) {
		var idx;
		var length = this._timerArray.length;
		var elementsToRemoveArray = new Array();
		var _g = 0;
		while(_g < length) {
			var idx1 = _g++;
			if(this._timerArray[idx1] != null && this._timerArray[idx1].nextTurn <= this.turnNumber) {
				Reflect.callMethod(this._timerArray[idx1].callerObject,this._timerArray[idx1].callbackFunc,[botAi]);
				if(this._timerArray[idx1].recurrence > 0) this._timerArray[idx1].nextTurn = this.turnNumber + this._timerArray[idx1].recurrence; else elementsToRemoveArray.push(this._timerArray[idx1]);
			}
		}
		while(elementsToRemoveArray.length > 0) {
			var sequence = elementsToRemoveArray.shift();
			this.removeTimer(sequence.callerObject,sequence.callbackFunc);
		}
	}
	,addTimer: function(callerObject,callbackFunc,startInNTurns,recurrence) {
		if(recurrence == null) recurrence = -1;
		if(startInNTurns == null) startInNTurns = 1;
		var sequence = { started : false, callerObject : callerObject, callbackFunc : callbackFunc, nextTurn : this.turnNumber + startInNTurns, recurrence : recurrence};
		this._timerArray.push(sequence);
	}
	,removeTimer: function(callerObject,callbackFunc) {
		var idx;
		var length = this._timerArray.length;
		var _g = 0;
		while(_g < length) {
			var idx1 = _g++;
			if(this._timerArray[idx1].callerObject == callerObject && Reflect.compareMethods(this._timerArray[idx1].callbackFunc,callbackFunc)) {
				this._timerArray.splice(idx1,1);
				break;
			}
		}
	}
	,addSequence: function(callerObject,callbackFunc) {
		var sequence = { started : false, callerObject : callerObject, callbackFunc : callbackFunc, nextTurn : -1, recurrence : -1};
		this._sequenceArray.push(sequence);
		if(this._isPlayingSequence == false) this.nextSequence();
	}
	,removeSequence: function(callerObject,callbackFunc) {
		var idx;
		var length = this._sequenceArray.length;
		var _g = 0;
		while(_g < length) {
			var idx1 = _g++;
			if(this._sequenceArray[idx1].callerObject == callerObject && Reflect.compareMethods(this._sequenceArray[idx1].callbackFunc,callbackFunc)) {
				this._sequenceArray.splice(idx1,1);
				break;
			}
		}
		if(this._sequenceArray.length > 0 && this._sequenceArray[0].started == false) this.nextSequence();
	}
	,nextSequence: function() {
		if(this._sequenceArray.length == 0) return;
		if(this._sequenceArray[0].started == true) this._sequenceArray.shift();
	}
};
org.zeroad.splitbot.core.Statistic = function() { };
org.zeroad.splitbot.core.Statistic.__name__ = true;
org.zeroad.splitbot.core.Statistic.choose = function(choicesArray,percentProbabilities) {
	if(choicesArray.length <= 0) return null;
	if(percentProbabilities == null) {
		var randomInt = Math.floor(Math.random() * choicesArray.length);
		return choicesArray[randomInt];
	}
	var randomPercent = Math.round(Math.random() * 100);
	var choice;
	var idx;
	var value = 0;
	var _g1 = 0;
	var _g = percentProbabilities.length;
	while(_g1 < _g) {
		var idx1 = _g1++;
		value += percentProbabilities[idx1];
		if(randomPercent <= value) return choicesArray[idx1];
	}
	return null;
};
org.zeroad.splitbot.core.Statistic.update = function(botAI) {
	var resources = org.zeroad.common_api.ResourceSupply.getRessourceArray(botAI);
	org.zeroad.splitbot.core.Statistic.foodCount = resources[0].count;
	org.zeroad.splitbot.core.Statistic.woodCount = resources[1].count;
	org.zeroad.splitbot.core.Statistic.stoneCount = resources[2].count;
	org.zeroad.splitbot.core.Statistic.metalCount = resources[3].count;
	var entities = botAI.entities;
	org.zeroad.splitbot.core.Statistic.peopleNumber = org.zeroad.splitbot.helper.EntityHelper.myPeopleUnits.length;
	org.zeroad.splitbot.core.Statistic.buildersNumber = org.zeroad.splitbot.helper.EntityHelper.myBuilderUnits.length;
	org.zeroad.splitbot.core.Statistic.buildingsNumber = org.zeroad.splitbot.helper.EntityHelper.myBuildingStructures.length;
};
org.zeroad.splitbot.helper.Debug0AD = function() {
};
org.zeroad.splitbot.helper.Debug0AD.__name__ = true;
org.zeroad.splitbot.helper.Debug0AD.init = function(botAI) {
	org.zeroad.splitbot.helper.Debug0AD.botAI = botAI;
};
org.zeroad.splitbot.helper.Debug0AD.cleanup = function() {
	org.zeroad.splitbot.helper.Debug0AD.botAI = null;
};
org.zeroad.splitbot.helper.Debug0AD.error = function(message) {
	org.zeroad.splitbot.helper.Debug0AD.botAI.chat("SplitBoat ERROR - " + message);
};
org.zeroad.splitbot.helper.Debug0AD.log = function(message) {
	org.zeroad.splitbot.helper.Debug0AD.botAI.chat("SplitBoat - " + message);
};
org.zeroad.splitbot.helper.Debug0AD.inspectObject = function(object) {
	var str = "{";
	var ff;
	var _g = 0;
	var _g1 = Reflect.fields(object);
	while(_g < _g1.length) {
		var ff1 = _g1[_g];
		++_g;
		str += "" + ff1 + "=" + Std.string(Reflect.field(object,ff1)) + ", ";
	}
	str += "}";
	return str;
};
org.zeroad.splitbot.helper.MapHelper = function() {
};
org.zeroad.splitbot.helper.MapHelper.__name__ = true;
org.zeroad.splitbot.helper.MapHelper.init = function(botAI) {
	org.zeroad.splitbot.helper.MapHelper.passabilityClasses = botAI.passabilityClasses;
	if(botAI.map != null) org.zeroad.splitbot.helper.MapHelper.passabilityMap = botAI.map; else org.zeroad.splitbot.helper.MapHelper.passabilityMap = botAI.passabilityMap;
};
org.zeroad.splitbot.helper.MapHelper.cleanup = function() {
	org.zeroad.splitbot.helper.MapHelper.passabilityClasses = null;
	org.zeroad.splitbot.helper.MapHelper.passabilityMap = null;
};
org.zeroad.splitbot.helper.MapHelper.isObstructed1Point = function(x,y,obstructionMask) {
	var mapData = org.zeroad.splitbot.helper.MapHelper.getMapDataAtCoord(x,y);
	if(mapData == null) return true;
	return (mapData & obstructionMask) > 0;
};
org.zeroad.splitbot.helper.MapHelper.isObstructed = function(point,width,height,entityTypes) {
	if(entityTypes.length <= 0) return null;
	var idx;
	var obstructionMask = org.zeroad.splitbot.helper.MapHelper.getPassabilityClassMask(entityTypes[0]);
	var _g1 = 1;
	var _g = entityTypes.length;
	while(_g1 < _g) {
		var idx1 = _g1++;
		obstructionMask |= org.zeroad.splitbot.helper.MapHelper.getPassabilityClassMask(entityTypes[idx1]);
	}
	var left = Math.floor(point.x - width / 2.0);
	var right = Math.ceil(left + width);
	var top = Math.floor(point.y - height / 2.0);
	var bottom = Math.ceil(top + height);
	var posX;
	var posY;
	var _g2 = left;
	while(_g2 < right) {
		var posX1 = _g2++;
		var _g11 = top;
		while(_g11 < bottom) {
			var posY1 = _g11++;
			if(org.zeroad.splitbot.helper.MapHelper.isObstructed1Point(posY1,posX1,obstructionMask)) return true;
		}
	}
	return false;
};
org.zeroad.splitbot.helper.MapHelper.getPassabilityClassMask = function(name) {
	if(!Reflect.hasField(org.zeroad.splitbot.helper.MapHelper.passabilityClasses,name)) org.zeroad.splitbot.helper.Debug0AD.error("Tried to use invalid passability class name '" + name + "'");
	return Reflect.field(org.zeroad.splitbot.helper.MapHelper.passabilityClasses,name);
};
org.zeroad.splitbot.helper.MapHelper.getMapDataAtCoord = function(x,y) {
	var scaledX = Math.round(x / 4);
	var scaledY = Math.round(y / 4);
	var position1D = scaledX + org.zeroad.splitbot.helper.MapHelper.passabilityMap.width * scaledY;
	if(position1D >= org.zeroad.splitbot.helper.MapHelper.passabilityMap.data.length || position1D < 0) return null;
	return org.zeroad.splitbot.helper.MapHelper.passabilityMap.data[position1D];
};
org.zeroad.splitbot.helper.MapHelper.isInTheMap = function(x,y) {
	return x < 0 || y < 0 || (x + org.zeroad.splitbot.helper.MapHelper.passabilityMap.width * y) / 4 < org.zeroad.splitbot.helper.MapHelper.passabilityMap.data.length;
};
var $_, $fid = 0;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; }
Math.NaN = Number.NaN;
Math.NEGATIVE_INFINITY = Number.NEGATIVE_INFINITY;
Math.POSITIVE_INFINITY = Number.POSITIVE_INFINITY;
Math.isFinite = function(i) {
	return isFinite(i);
};
Math.isNaN = function(i1) {
	return isNaN(i1);
};
String.__name__ = true;
Array.__name__ = true;
Date.__name__ = ["Date"];
Main.settings = { player : null, templates : []};
org.zeroad.common_api.ResourceSupplyTypeValue.FOOD = "food";
org.zeroad.common_api.ResourceSupplyTypeValue.WOOD = "wood";
org.zeroad.common_api.ResourceSupplyTypeValue.STONE = "stone";
org.zeroad.common_api.ResourceSupplyTypeValue.METAL = "metal";
org.zeroad.splitbot.agent.Agent.ENTITY_META_OWNER_ID = "ENTITY_META_OWNER_ID";
org.zeroad.splitbot.agent.Agent._nextId = 0;
org.zeroad.splitbot.agent.AttackerAgent.AttackerAgentUpdateFrequency = 250;
org.zeroad.splitbot.agent.BuilderAgent.GOOD_TEMPLATE_NAMES = [];
org.zeroad.splitbot.agent.BuilderAgent.MARGIN_BETWEEN_BUILDINGS = 20;
org.zeroad.splitbot.agent.BuilderAgent.MAX_TURNS_BEFORE_BUILDING_START = 200;
org.zeroad.splitbot.agent.ChiefAgent.ChiefAgentUpdateFrequency = 2;
org.zeroad.splitbot.agent.ChiefAgent.ChiefAgentSpeakFrequency = 100;
org.zeroad.splitbot.agent.DefenderAgent.DefenderAgentUpdateFrequency = 50;
org.zeroad.splitbot.agent.DefenderAgent.ENEMY_PRESENCE_TIME_TOLERANCE = 1;
org.zeroad.splitbot.agent.DefenderAgent.ENEMY_DISTANCE_TOLERANCE = 160;
org.zeroad.splitbot.helper.EntityHelper.FOUNDATION_OBSTRUCTION = "foundationObstruction";
org.zeroad.splitbot.helper.EntityHelper.BUILDING_LAND_OBSTRUCTION = "building-land";
org.zeroad.splitbot.helper.EntityHelper.PATHFINDER_OBSTRUCTION = "pathfinderObstruction";
org.zeroad.splitbot.helper.EntityHelper.DEFAULT_OBSTRUCTION = "default";
org.zeroad.splitbot.helper.EntityHelper.SHIP_OBSTRUCTION = "ship";
org.zeroad.splitbot.helper.EntityHelper.BUILDING_SHORE_OBSTRUCTION = "building-shore";
org.zeroad.splitbot.helper.EntityHelper.UNRESTRICTED_OBSTRUCTION = "unrestricted";
org.zeroad.splitbot.helper.EntityHelper.CLASS_STRUCTURE = "Structure";
org.zeroad.splitbot.helper.EntityHelper.CLASS_MECHANICAL = "Mechanical";
org.zeroad.splitbot.helper.EntityHelper.CLASS_SIEGE = "Siege";
org.zeroad.splitbot.helper.EntityHelper.CLASS_BUILDER = "Builder";
org.zeroad.splitbot.helper.EntityHelper.CLASS_WORKER = "Worker";
org.zeroad.splitbot.helper.EntityHelper.CLASS_CITIZEN_SOLDIER = "CitizenSoldier";
org.zeroad.splitbot.helper.EntityHelper.CIV_HELE = "hele";
org.zeroad.splitbot.helper.EntityHelper.CIV_CELT = "celt";
org.zeroad.splitbot.helper.EntityHelper.CIV_IBER = "iber";
org.zeroad.splitbot.helper.EntityHelper.CIV_CART = "cart";
org.zeroad.splitbot.helper.EntityHelper.CIV_GAIA = "gaia";
org.zeroad.splitbot.agent.MachinaSexualAgent.BAD_TEMPLATE_NAMES = [org.zeroad.splitbot.helper.EntityHelper.UNIT_CAVALRY_JAVELINIST,org.zeroad.splitbot.helper.EntityHelper.UNIT_CAVALRY_SPEARMAN,org.zeroad.splitbot.helper.EntityHelper.UNIT_CAVALRY_SWORDSMAN,org.zeroad.splitbot.helper.EntityHelper.UNIT_CHAMPION_CAVALRY_BRIT,org.zeroad.splitbot.helper.EntityHelper.UNIT_CHAMPION_CAVALRY_GAUL];
org.zeroad.splitbot.agent.WorkerAgent.MAX_ACCEPTABLE_DISTANCE_OF_A_RESOURCE = 200;
org.zeroad.splitbot.helper.Debug0AD.activated = true;
org.zeroad.splitbot.helper.MapHelper.TILE_SIZE = 4;
Main.main();
