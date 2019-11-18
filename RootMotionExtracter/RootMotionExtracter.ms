global isXAxisChecked = false 
global isYAxisChecked = false 
global isYawChecked = false 
fn makeRootMotion bwithX bwithY bwithYaw = -- bool bool bool 
(
	if bWithX != false do 
	(

		if $Bip001.parent != $Root do 
		(
			$Bip001.parent = $Root 
		)

		isRootSubHere = isValidNode $Root_Sub

		if isRootSubHere == false do 
		(
			A = Dummy()
			A.name = "Root_Sub"
			A.parent = $Root
			$Bip001.parent = $Root_Sub 	
		)

		setInheritanceFlags $Root_sub #{7..9}

		sleep 1 

		sobj = $Root
		tobj = $Bip001

		select $Root_Sub
		setInheritanceFlags $Root_sub #{7..9}

		redrawViews() 	 

		astart = animationrange.start
		aend = animationrange.end

		stepCount = 1 

		Exposer = Dummy() 

		PropExposer = Dummy() 

		CAMExposer = Dummy()

		Try 
		(
			$'Link_Camera'.parent = world 
		)
		Catch() 

		animate on
		(
			for i =astart to aend do
			(
				slidertime = i
				sobj.transform = tobj.transform
				Exposer.transform = $Bip001.transform 

				Try 
				(
					PropExposer.transform = $Bip001_Prop1.transform 
					CAMExposer.transform = $'Link_Camera'.transform 
				)
				Catch() 

				
				if IsKindOf sobj Biped_Object then
				(
					biped.setTransform sobj #pos tobj.transform.position true
					biped.setTransform sobj #rotation tobj.transform.rotation true
				)
			)
		)
		SliderTime = 0f 
		
		$Root.transform = $Root_Sub.transform 
		DeleteKeys $Root.position.controller.Z_Position.controller #allKeys
		DeleteKeys $Root.rotation.controller.X_Rotation.controller #allKeys
		DeleteKeys $Root.rotation.controller.Y_Rotation.controller #allKeys

		iExtractOption = (bwithX as integer) + (bwithY as integer) + (bwithYaw as integer)

		case iExtractOption of 
		(
			1: -- extract Only X Pos 
			(
				DeleteKeys $Root.position.controller.X_Position.controller #allKeys
				DeleteKeys $Root.rotation.controller.Z_Rotation.controller #allKeys 
			)
			2: -- extract X, Y Pos 
			(
				DeleteKeys $Root.rotation.controller.Z_Rotation.controller #allKeys 
			)
			3: --extract all 
			()
		)


		--DeleteKeys $Root.rotation.controller.Z_Rotation.controller #allKeys

		delete $Root_Sub 
		biped.createLayer $Bip001.controller 1 "RMotionLayer01"
		
		$Bip001.parent = $Root 

		Try 
		(
			$'Link_Camera'.parent = $'Root' 
		)
		Catch() 

		set Animate on 
		for i = AnimationRange.start to AnimationRange.end do 
		(
			SliderTime = i 
			$Bip001.transform = Exposer.transform 
			
			Try 
			(
				$'Bip001 Prop1'.transform = PropExposer.transform 
				$'Link_Camera'.transform = CAMExposer.transform 
			)
			Catch() 
		)

		sliderTime = 0f

		delete Exposer 
		delete propExposer 
		delete CAMExposer 

	--Special Thanks to JJ and Nopie

	-- Script by Minomi /
	)
)



Rollout RootMotionMaker "Extract Root Motion"
(

	--checkBox extractRootMotion "Extract Root Motion"
	Group "Extract Position"
	(
		checkBox extractFront "Extract Front / Back" across:2 tooltip:"Front -> Right -> Yaw 순으로 활성화됩니다."
		checkBox extractRight "Extract Right / Left" enabled:false 
	)
	Group "Extract Rotation"
	(
		checkBox extractYaw "Extract Yaw Rotation" enabled:false 
	)

	--checkButton chkRMWithRotationValue "Extract with Rotation"
	--Button btnMake "Make RootMotion"
	
	on extractFront changed val do 
	(
		if val == true then 
		(
			isXAxisChecked = true 

			extractRight.enabled = true 
		)
		else 
		(
			isXAxisChecked = false 
			extractRight.enabled = false 
		)

	)

	on extractRight changed val do 
	(
		if val == true then 
		(
			isYAxisChecked = true 
			extractYaw.enabled = true  
		)
		else 
		(
			isYAxisChecked = false
			extractYaw.enabled = false  
		)

	)

	on extractYaw changed val do 
	(
		if val = true then 
		(
			isYawChecked = true 
		)
		else 
		(
			isYawChecked = false 
		)
	)

)--createDialog RootMotionMaker 505 200

--월요일날 출근해서 ROtation 제대로 추출 못하는지 알아보기 
-- Gimbal일것같음