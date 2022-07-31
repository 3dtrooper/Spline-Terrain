-- 3DTrooper SplineTerrain
-- V 0.1   02.03.2019
-- 	

try (
	destroyDialog  TDT_SplineTerrain
	) catch()
	

rollout TDT_SplineTerrain "TDT_SplineTerrain" width:86 height:96
(

	button 'btn_basic_terrain' "CreateTerrain" pos:[8,8] width:70 height:16 toolTip:"Create Splines and Terrain Object and Maps" align:#left
	spinner 'spn_basic_terrain' "" pos:[8,48] width:64 height:16 range:[0,5000,50] type:#integer scale:1 align:#left
	groupBox 'grp_Width' "Spline Knots" pos:[3,32] width:72 height:40 align:#left
	checkbox 'chk_CreateGeometry' "Terrain" pos:[8,72] width:64 height:16 enabled:true checked:false align:#left
		
	
	on btn_basic_terrain pressed do
	(
		
		sp = splineShape name: "TerrainShape" render_renderable:true render_mapcoords:true
		ammountS = (spn_basic_terrain.value)
		for i = 1 to ammountS do (
			addnewSpline sp
			for m = 1 to ammountS do (
				addKnot sp i #corner #line [(m*10),(i*10),0]
			)
		)	
		
		updateShape sp
		select sp
			
			smap= ShapeMap ()
			circleShape = Circle radius:30 pos:[0,0,0]
			smap.shapeobject = circleShape
			smap.coords.blur = 20
			Nm = noise()
			Nm.size = 30
			Nm.name = "SplineDisplNoise"
			mixm = mix()
			mixm.mixAmount = 50
			mixm.map1  = Nm
			mixm.map2 = smap
			
			addmodifier sp (Displace ())				
				sp.modifiers[#Displace].useMap = on
				sp.modifiers[#Displace].strength = 20
				sp.modifiers[#Displace].map = mixm  
				if Normalize_Spline2 == undefined then
				(
				addmodifier sp (Normalize_Spl())
				sp.modifiers[#Normalize_Spl].enabled = false
					)		
				else
					(
				addmodifier sp (Normalize_Spline2 ())
				sp.modifiers[#Normalize_Spline].length = 5	
				sp.modifiers[#Normalize_Spline].enabled = false
				)
					
		if chk_CreateGeometry.state == true do
			(		
			terr = Terrain name:"TerrainComp" form:2
				-- generate some maps
				cm = checker()
				cm.color2 = [128,128,128]
				cm.name = "TerrainChecker"
				tm = noise()
				tm.size = 10
				tm.name = "TerrainDisplNoise"
			terr.material = standard diffuseMap:(cm) showInViewport:true name:"TerrainMat_1"
			terrainOps.addOperand terr sp
				addmodifier terr (TurboSmooth ())
					terr.modifiers[#TurboSmooth].enabled = false
				addmodifier terr (Uvwmap ())	
					terr.modifiers[#UVW_Map].maptype = 4
					terr.modifiers[#UVW_Map].length = 10
					terr.modifiers[#UVW_Map].width = 10
					terr.modifiers[#UVW_Map].height = 10
				addmodifier terr (Uvwmap name:"UVW_Map_Ch2")	
					terr.modifiers[#UVW_Map_Ch2].axis = 0
					terr.modifiers[#UVW_Map_Ch2].mapChannel = 2
					terr.modifiers[#UVW_Map_Ch2].length = 110
					terr.modifiers[#UVW_Map_Ch2].width = 110			
				addmodifier terr (Displace ())				
					terr.modifiers[#Displace].enabled = false
					terr.modifiers[#Displace].useMap = on
					terr.modifiers[#Displace].strength = 1
					terr.modifiers[#Displace].map = tm 
				--addmodifier terr (Edit_Poly())
			)
		)
)
			
createDialog TDT_SplineTerrain
	
	
	
	

	
	
	
	
