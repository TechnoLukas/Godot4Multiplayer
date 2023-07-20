GDPC                 �                                                                         P   res://.godot/exported/133200997/export-3070c538c03ee49b7677ff960a3f5195-main.scn      %      �o�S���S���    T   res://.godot/exported/133200997/export-36a25e342948d0ceacc500772b5412b3-player.scn  @      i&      x3g�&l����+S��G    ,   res://.godot/global_script_class_cache.cfg  �i      T      �����;_0N4N�    D   res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex�      ^      2��r3��MgB�[79       res://.godot/uid_cache.bin  ��      V       ֜R:ݕs�>ŏ6       res://global.gd         /       Z)�%�9�]n-�'�>       res://headless.gd   0       �      ��xs������C���       res://icon.svg  0}      N      ]��s�9^w/�����       res://icon.svg.import   @      �       S��ý�Y(�ii���ԧ       res://main.tscn.remap   �h      a       �J�Sw� ������       res://player.gd  6      �	      ��Fۄ�<��2>��J�       res://player.tscn.remap `i      c       ������T�?�L���       res://project.binary��      �
      �����)}|r)g,       res://world.gd  �f      m      2<+R�C�M=Y��S"    Nt�H�*�^=^extends Node

var color = ""
var nickname = ""
extends Node3D

@onready var main_menu = $Menu

const Player=preload("res://player.tscn")
const PORT=9999

var peer = WebSocketMultiplayerPeer.new()

func _init():
	peer.supported_protocols = ["ludus"]

func _ready():
	main_menu.hide()
	multiplayer.multiplayer_peer=null
	peer.create_server(PORT)
	multiplayer.multiplayer_peer=peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)

func add_player(peer_id):
	var player = Player.instantiate()
	player.name = str(peer_id)
	player.visible=false
	add_child(player)
	
func remove_player(peer_id):
	var player = get_node_or_null(str(peer_id))
	if player:
		player.queue_free()
�Mx�3] V4��GST2   �   �      ����               � �        &  RIFF  WEBPVP8L  /������!"2�H�l�m�l�H�Q/H^��޷������d��g�(9�$E�Z��ߓ���'3���ض�U�j��$�՜ʝI۶c��3� [���5v�ɶ�=�Ԯ�m���mG�����j�m�m�_�XV����r*snZ'eS�����]n�w�Z:G9�>B�m�It��R#�^�6��($Ɓm+q�h��6�4mb�h3O���$E�s����A*DV�:#�)��)�X/�x�>@\�0|�q��m֋�d�0ψ�t�!&����P2Z�z��QF+9ʿ�d0��VɬF�F� ���A�����j4BUHp�AI�r��ِ���27ݵ<�=g��9�1�e"e�{�(�(m�`Ec\]�%��nkFC��d���7<�
V�Lĩ>���Qo�<`�M�$x���jD�BfY3�37�W��%�ݠ�5�Au����WpeU+.v�mj��%' ��ħp�6S�� q��M�׌F�n��w�$$�VI��o�l��m)��Du!SZ��V@9ד]��b=�P3�D��bSU�9�B���zQmY�M~�M<��Er�8��F)�?@`�:7�=��1I]�������3�٭!'��Jn�GS���0&��;�bE�
�
5[I��=i�/��%�̘@�YYL���J�kKvX���S���	�ڊW_�溶�R���S��I��`��?֩�Z�T^]1��VsU#f���i��1�Ivh!9+�VZ�Mr�טP�~|"/���IK
g`��MK�����|CҴ�ZQs���fvƄ0e�NN�F-���FNG)��W�2�JN	��������ܕ����2
�~�y#cB���1�YϮ�h�9����m������v��`g����]1�)�F�^^]Rץ�f��Tk� s�SP�7L�_Y�x�ŤiC�X]��r�>e:	{Sm�ĒT��ubN����k�Yb�;��Eߝ�m�Us�q��1�(\�����Ӈ�b(�7�"�Yme�WY!-)�L���L�6ie��@�Z3D\?��\W�c"e���4��AǘH���L�`L�M��G$𩫅�W���FY�gL$NI�'������I]�r��ܜ��`W<ߛe6ߛ�I>v���W�!a��������M3���IV��]�yhBҴFlr�!8Մ�^Ҷ�㒸5����I#�I�ڦ���P2R���(�r�a߰z����G~����w�=C�2������C��{�hWl%��и���O������;0*��`��U��R��vw�� (7�T#�Ƨ�o7�
�xk͍\dq3a��	x p�ȥ�3>Wc�� �	��7�kI��9F}�ID
�B���
��v<�vjQ�:a�J�5L&�F�{l��Rh����I��F�鳁P�Nc�w:17��f}u}�Κu@��`� @�������8@`�
�1 ��j#`[�)�8`���vh�p� P���׷�>����"@<�����sv� ����"�Q@,�A��P8��dp{�B��r��X��3��n$�^ ��������^B9��n����0T�m�2�ka9!�2!���]
?p ZA$\S��~B�O ��;��-|��
{�V��:���o��D��D0\R��k����8��!�I�-���-<��/<JhN��W�1���(�#2:E(*�H���{��>��&!��$| �~�+\#��8�> �H??�	E#��VY���t7���> 6�"�&ZJ��p�C_j����	P:�~�G0 �J��$�M���@�Q��Yz��i��~q�1?�c��Bߝϟ�n�*������8j������p���ox���"w���r�yvz U\F8��<E��xz�i���qi����ȴ�ݷ-r`\�6����Y��q^�Lx�9���#���m����-F�F.-�a�;6��lE�Q��)�P�x�:-�_E�4~v��Z�����䷳�:�n��,㛵��m�=wz�Ξ;2-��[k~v��Ӹ_G�%*�i� ����{�%;����m��g�ez.3���{�����Kv���s �fZ!:� 4W��޵D��U��
(t}�]5�ݫ߉�~|z��أ�#%���ѝ܏x�D4�4^_�1�g���<��!����t�oV�lm�s(EK͕��K�����n���Ӌ���&�̝M�&rs�0��q��Z��GUo�]'G�X�E����;����=Ɲ�f��_0�ߝfw�!E����A[;���ڕ�^�W"���s5֚?�=�+9@��j������b���VZ^�ltp��f+����Z�6��j�`�L��Za�I��N�0W���Z����:g��WWjs�#�Y��"�k5m�_���sh\���F%p䬵�6������\h2lNs�V��#�t�� }�K���Kvzs�>9>�l�+�>��^�n����~Ěg���e~%�w6ɓ������y��h�DC���b�KG-�d��__'0�{�7����&��yFD�2j~�����ټ�_��0�#��y�9��P�?���������f�fj6͙��r�V�K�{[ͮ�;4)O/��az{�<><__����G����[�0���v��G?e��������:���١I���z�M�Wۋ�x���������u�/��]1=��s��E&�q�l�-P3�{�vI�}��f��}�~��r�r�k�8�{���υ����O�֌ӹ�/�>�}�t	��|���Úq&���ݟW����ᓟwk�9���c̊l��Ui�̸z��f��i���_�j�S-|��w�J�<LծT��-9�����I�®�6 *3��y�[�.Ԗ�K��J���<�ݿ��-t�J���E�63���1R��}Ғbꨝט�l?�#���ӴQ��.�S���U
v�&�3�&O���0�9-�O�kK��V_gn��k��U_k˂�4�9�v�I�:;�w&��Q�ҍ�
��fG��B��-����ÇpNk�sZM�s���*��g8��-���V`b����H���
3cU'0hR
�w�XŁ�K݊�MV]�} o�w�tJJ���$꜁x$��l$>�F�EF�޺�G�j�#�G�t�bjj�F�б��q:�`O�4�y�8`Av<�x`��&I[��'A�˚�5��KAn��jx ��=Kn@��t����)�9��=�ݷ�tI��d\�M�j�B�${��G����VX�V6��f�#��V�wk ��W�8�	����lCDZ���ϖ@���X��x�W�Utq�ii�D($�X��Z'8Ay@�s�<�x͡�PU"rB�Q�_�Q6  E�[remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://dibi3yakk3yo1"
path="res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex"
metadata={
"vram_texture": false
}
 ,��.w�|���RSRC                    PackedScene            ��������                                            �      ..    resource_local_to_scene    resource_name    render_priority 
   next_pass    transparency    blend_mode 
   cull_mode    depth_draw_mode    no_depth_test    shading_mode    diffuse_mode    specular_mode    disable_ambient_light    vertex_color_use_as_albedo    vertex_color_is_srgb    albedo_color    albedo_texture    albedo_texture_force_srgb    albedo_texture_msdf 	   metallic    metallic_specular    metallic_texture    metallic_texture_channel 
   roughness    roughness_texture    roughness_texture_channel    emission_enabled 	   emission    emission_energy_multiplier    emission_operator    emission_on_uv2    emission_texture    normal_enabled    normal_scale    normal_texture    rim_enabled    rim 	   rim_tint    rim_texture    clearcoat_enabled 
   clearcoat    clearcoat_roughness    clearcoat_texture    anisotropy_enabled    anisotropy    anisotropy_flowmap    ao_enabled    ao_light_affect    ao_texture 
   ao_on_uv2    ao_texture_channel    heightmap_enabled    heightmap_scale    heightmap_deep_parallax    heightmap_flip_tangent    heightmap_flip_binormal    heightmap_texture    heightmap_flip_texture    subsurf_scatter_enabled    subsurf_scatter_strength    subsurf_scatter_skin_mode    subsurf_scatter_texture &   subsurf_scatter_transmittance_enabled $   subsurf_scatter_transmittance_color &   subsurf_scatter_transmittance_texture $   subsurf_scatter_transmittance_depth $   subsurf_scatter_transmittance_boost    backlight_enabled 
   backlight    backlight_texture    refraction_enabled    refraction_scale    refraction_texture    refraction_texture_channel    detail_enabled    detail_mask    detail_blend_mode    detail_uv_layer    detail_albedo    detail_normal 
   uv1_scale    uv1_offset    uv1_triplanar    uv1_triplanar_sharpness    uv1_world_triplanar 
   uv2_scale    uv2_offset    uv2_triplanar    uv2_triplanar_sharpness    uv2_world_triplanar    texture_filter    texture_repeat    disable_receive_shadows    shadow_to_opacity    billboard_mode    billboard_keep_scale    grow    grow_amount    fixed_size    use_point_size    point_size    use_particle_trails    proximity_fade_enabled    proximity_fade_distance    msdf_pixel_range    msdf_outline_size    distance_fade_mode    distance_fade_min_distance    distance_fade_max_distance    script    background_mode    background_color    background_energy_multiplier    background_intensity    background_canvas_max_layer    background_camera_feed_id    sky    sky_custom_fov    sky_rotation    ambient_light_source    ambient_light_color    ambient_light_sky_contribution    ambient_light_energy    reflected_light_source    tonemap_mode    tonemap_exposure    tonemap_white    ssr_enabled    ssr_max_steps    ssr_fade_in    ssr_fade_out    ssr_depth_tolerance    ssao_enabled    ssao_radius    ssao_intensity    ssao_power    ssao_detail    ssao_horizon    ssao_sharpness    ssao_light_affect    ssao_ao_channel_affect    ssil_enabled    ssil_radius    ssil_intensity    ssil_sharpness    ssil_normal_rejection    sdfgi_enabled    sdfgi_use_occlusion    sdfgi_read_sky_light    sdfgi_bounce_feedback    sdfgi_cascades    sdfgi_min_cell_size    sdfgi_cascade0_distance    sdfgi_max_distance    sdfgi_y_scale    sdfgi_energy    sdfgi_normal_bias    sdfgi_probe_bias    glow_enabled    glow_levels/1    glow_levels/2    glow_levels/3    glow_levels/4    glow_levels/5    glow_levels/6    glow_levels/7    glow_normalized    glow_intensity    glow_strength 	   glow_mix    glow_bloom    glow_blend_mode    glow_hdr_threshold    glow_hdr_scale    glow_hdr_luminance_cap    glow_map_strength 	   glow_map    fog_enabled    fog_light_color    fog_light_energy    fog_sun_scatter    fog_density    fog_aerial_perspective    fog_sky_affect    fog_height    fog_height_density    volumetric_fog_enabled    volumetric_fog_density    volumetric_fog_albedo    volumetric_fog_emission    volumetric_fog_emission_energy    volumetric_fog_gi_inject    volumetric_fog_anisotropy    volumetric_fog_length    volumetric_fog_detail_spread    volumetric_fog_ambient_inject    volumetric_fog_sky_affect -   volumetric_fog_temporal_reprojection_enabled ,   volumetric_fog_temporal_reprojection_amount    adjustment_enabled    adjustment_brightness    adjustment_contrast    adjustment_saturation    adjustment_color_correction    content_margin_left    content_margin_top    content_margin_right    content_margin_bottom    color    grow_begin 	   grow_end 
   thickness 	   vertical 	   bg_color    draw_center    skew    border_width_left    border_width_top    border_width_right    border_width_bottom    border_color    border_blend    corner_radius_top_left    corner_radius_top_right    corner_radius_bottom_right    corner_radius_bottom_left    corner_detail    expand_margin_left    expand_margin_top    expand_margin_right    expand_margin_bottom    shadow_color    shadow_size    shadow_offset    anti_aliasing    anti_aliasing_size 	   _bundled       Script    res://headless.gd ��������   !   local://StandardMaterial3D_yt530 �         local://Environment_o5wio 6         local://StyleBoxLine_lk1rc R         local://StyleBoxFlat_voseq �         local://StyleBoxFlat_82y2s          local://StyleBoxFlat_mqmdb �         local://StyleBoxFlat_alhut �         local://PackedScene_fiemq c         StandardMaterial3D          ��$>���>���>  �?n         Environment    n         StyleBoxLine    �      ���>���>���>  �?�         n         StyleBoxFlat    �      ;��>;��>;��>  �?�                    �?�         �         �         �         �         n         StyleBoxFlat    �                  ��/?�         �         �         �         n         StyleBoxFlat    �      ��?��?��?    n         StyleBoxFlat 
   �        �?  �?  �?  �?�      (   �      <   �        �?  �?  �?  �?�      
   �      
   �      
   �      
   �        �?  �?  �?��?n         PackedScene    �      	         names "   ;      Node3D    script 	   CSGBox3D    material_override    use_collision    size    WorldEnvironment    environment    DirectionalLight3D 
   transform    Menu    layout_mode    anchors_preset    anchor_right    anchor_bottom    grow_horizontal    grow_vertical    Control    background    color 
   ColorRect    VBoxContainer    anchor_left    anchor_top    offset_left    offset_top    offset_right    offset_bottom $   theme_override_constants/separation    joinbt    size_flags_vertical $   theme_override_font_sizes/font_size    text    Button    addressinp    placeholder_text 
   alignment 	   LineEdit    HSeparator     theme_override_styles/separator    nicknamenp    theme_override_styles/panel    Panel    HBoxContainer    Label    size_flags_horizontal    ColorPickerButton    theme_override_styles/normal    theme_override_styles/pressed    theme_override_styles/hover    theme_override_styles/disabled    theme_override_styles/focus    MultiplayerSpawner    _spawnable_scenes    spawn_path    _on_joinbt_pressed    pressed    _on_addressinp_text_submitted    text_submitted    	   variants    %                                   A���=   A              �?            �5?�5?    �5��5?      @@                     �?               ��X>��X>��X>  �?            ?     ;�     �     ;C     hC   2         Join    
   localhost       enter address    ����            	   nickname             ff&@            	     color:             ����      A      �              �?  �?  �?  �?"         res://player.tscn                 node_count             nodes     >  ��������        ����                            ����                                       ����                           ����   	                     
   ����                              	      	                    ����      
                        	      	                          ����      
                                                            	      	                    !      ����      	                                 %   "   ����      	                      #      $   
              &   &   ����      	         '                 %   (   ����      	               #      $   
              *      ����      	         )                 *      ����	      
                              	      	         )                 +   +   ����      
                        	      	                    ,   ,   ����      	   -         
                           *   *   ����      	   -      )                 .   .   ����      
                                                  	      	   -      /   !   0   !   1   !   2   !   3   !      "               4   4   ����   5   #   6   $             conn_count             conns               8   7                     :   9              
       :   9                    node_paths              editable_instances              version       n      RSRCextends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var mesh = $CSGMesh3D
@onready var camera = $Camera3D
@onready var anim_player = $AnimationPlayer

@onready var fltwd = $SubViewport/window

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())
	

func _ready():
	if not is_multiplayer_authority(): return
	
	fltwd.get_node("nick").text=Global.nickname
	fltwd.get_node("color").color=Global.color
	#fltwd.get_node("nick").theme.set_color()
	
	
	#mesh.mesh.material.albedo_color=fltwd.get_node("color").color
	print(mesh.mesh.material.albedo_color)
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	position=Vector3(randf_range(-5,5),2,randf_range(-5,5))
	visible=true
	camera.current=true

func _unhandled_input(event):
	if not is_multiplayer_authority(): return
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.is_action_just_pressed("ui_focus_next"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x*.005)
		camera.rotate_x(-event.relative.y*.005)
		camera.rotation.x=clamp(camera.rotation.x,-PI/2,PI/2)
		
	if Input.is_action_just_pressed("shoot") and anim_player.current_animation != "shoot" and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		play_shoot_effects()#.rpc()

func _physics_process(delta):
	if not is_multiplayer_authority(): return
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if anim_player.current_animation == "shoot" :
		pass
	elif input_dir != Vector2.ZERO and is_on_floor() and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		anim_player.play("walk")
	else:
		anim_player.play("idle")

	move_and_slide()

func play_shoot_effects():
	anim_player.stop()
	anim_player.play("shoot")
W�C�u ���P���RSRC                    PackedScene            ��������                                            �      .. 	   Camera3D    Pistol 	   position 	   rotation    SubViewport    .    AnimationPlayer    current_animation    visible    window    nick    text    color    resource_local_to_scene    resource_name    render_priority 
   next_pass    transparency    blend_mode 
   cull_mode    depth_draw_mode    no_depth_test    shading_mode    diffuse_mode    specular_mode    disable_ambient_light    vertex_color_use_as_albedo    vertex_color_is_srgb    albedo_color    albedo_texture    albedo_texture_force_srgb    albedo_texture_msdf 	   metallic    metallic_specular    metallic_texture    metallic_texture_channel 
   roughness    roughness_texture    roughness_texture_channel    emission_enabled 	   emission    emission_energy_multiplier    emission_operator    emission_on_uv2    emission_texture    normal_enabled    normal_scale    normal_texture    rim_enabled    rim 	   rim_tint    rim_texture    clearcoat_enabled 
   clearcoat    clearcoat_roughness    clearcoat_texture    anisotropy_enabled    anisotropy    anisotropy_flowmap    ao_enabled    ao_light_affect    ao_texture 
   ao_on_uv2    ao_texture_channel    heightmap_enabled    heightmap_scale    heightmap_deep_parallax    heightmap_flip_tangent    heightmap_flip_binormal    heightmap_texture    heightmap_flip_texture    subsurf_scatter_enabled    subsurf_scatter_strength    subsurf_scatter_skin_mode    subsurf_scatter_texture &   subsurf_scatter_transmittance_enabled $   subsurf_scatter_transmittance_color &   subsurf_scatter_transmittance_texture $   subsurf_scatter_transmittance_depth $   subsurf_scatter_transmittance_boost    backlight_enabled 
   backlight    backlight_texture    refraction_enabled    refraction_scale    refraction_texture    refraction_texture_channel    detail_enabled    detail_mask    detail_blend_mode    detail_uv_layer    detail_albedo    detail_normal 
   uv1_scale    uv1_offset    uv1_triplanar    uv1_triplanar_sharpness    uv1_world_triplanar 
   uv2_scale    uv2_offset    uv2_triplanar    uv2_triplanar_sharpness    uv2_world_triplanar    texture_filter    texture_repeat    disable_receive_shadows    shadow_to_opacity    billboard_mode    billboard_keep_scale    grow    grow_amount    fixed_size    use_point_size    point_size    use_particle_trails    proximity_fade_enabled    proximity_fade_distance    msdf_pixel_range    msdf_outline_size    distance_fade_mode    distance_fade_min_distance    distance_fade_max_distance    script    lightmap_size_hint 	   material    custom_aabb    flip_faces    add_uv2    uv2_padding    radius    height    radial_segments    rings    custom_solver_bias    margin    length 
   loop_mode    step    tracks/0/type    tracks/0/imported    tracks/0/enabled    tracks/0/path    tracks/0/interp    tracks/0/loop_wrap    tracks/0/keys    tracks/1/type    tracks/1/imported    tracks/1/enabled    tracks/1/path    tracks/1/interp    tracks/1/loop_wrap    tracks/1/keys    _data    viewport_path    properties/0/path    properties/0/spawn    properties/0/sync    properties/0/watch    properties/1/path    properties/1/spawn    properties/1/sync    properties/1/watch    properties/2/path    properties/2/spawn    properties/2/sync    properties/2/watch    properties/3/path    properties/3/spawn    properties/3/sync    properties/3/watch    properties/4/path    properties/4/spawn    properties/4/sync    properties/4/watch    properties/5/path    properties/5/spawn    properties/5/sync    properties/5/watch    properties/6/path    properties/6/spawn    properties/6/sync    properties/6/watch 	   _bundled       Script    res://player.gd ��������   !   local://StandardMaterial3D_410lr <         local://CapsuleMesh_oky1a k         local://CapsuleShape3D_yabfh �      !   local://StandardMaterial3D_u6ugc �      !   local://StandardMaterial3D_5s6t3 �         local://Animation_nsie2 8         local://Animation_b8h3t          local://Animation_3auxi 9         local://Animation_pnrlq U         local://AnimationLibrary_ysr4l �         local://ViewportTexture_fv0f2 A      %   local://SceneReplicationConfig_jvrmg q         local://PackedScene_5acnn 0         StandardMaterial3D             {         CapsuleMesh             }             {         CapsuleShape3D    {         StandardMaterial3D          ���<���<���<  �?{         StandardMaterial3D          ��d>��d>��d>  �?{      
   Animation    �      o�:�         value �          �         �              �         �         �               times !                transitions !        �?      values             ?��̾D33�      update        �         value �          �         �              �         �         �               times !                transitions !        �?      values                            update        {      
   Animation             idle �         @�         �         value �          �         �              �         �         �               times !            �?      transitions !         �   �      values             ?��̾D33�      ?4��D33�      update        �         value �          �         �              �         �         �               times !            �?      transitions !         �   �      values                         �2>              update        {      
   Animation             shoot �      ���>�         value �          �         �              �         �         �               times !          ���>      transitions !         ?   ?      values             ?x����K�      ?��̾D33�      update        �         value �          �         �              �         �         �               times !          ���>      transitions !         ?   ?      values          �&?                             update        {      
   Animation 
            walk �         �         value �          �         �              �         �         �               times !            �>   ?ffF?      transitions !         ?   @   ?   @      values             ?��̾D33�   ���>Bү�D33�      ?��̾D33�   0�?�Ω�D33�      update        {         AnimationLibrary    �               RESET                idle                shoot                walk          {         ViewportTexture    �            {         SceneReplicationConfig    �              �         �         �          �              �         �         �          �              �         �         �          �              �         �         �          �           	   �         �         �          �           
         �         �         �          �           
         �         �         �          {         PackedScene    �      	         names "   1      player    script    CharacterBody3D 
   CSGMesh3D 
   transform    mesh    CollisionShape3D    shape 	   Camera3D    Pistol    Node3D 	   CSGBox3D    size 	   material    AnimationPlayer 
   root_node 	   autoplay    playback_default_blend_time 
   libraries    Label    anchors_preset    anchor_left    anchor_top    anchor_right    anchor_bottom    offset_left    offset_top    offset_right    offset_bottom    grow_horizontal    grow_vertical $   theme_override_font_sizes/font_size    text    horizontal_alignment    vertical_alignment    SubViewport    window    layout_mode    Control    color 
   ColorRect    nick    FloatingWindow 
   billboard    double_sided    texture 	   Sprite3D    MultiplayerSynchronizer    replication_config    	   variants    $                  �?              �?              �?      �?                           �?              �?              �?      �?         �?              �?              �?   ?��̾D33�     �?              �?              �?        ��̽   )��=#P�=�'�>              �?              �?              �?    �jŽ'0�=   )��=#P�=���=                            idle )   �������?                   	               ?     ��     ��     �A     �A         $         ➕       -   W                       �?   ��p>��p>��p>  �?      TEXT      �?              �?              �?    X�@                 
                  node_count             nodes     �   ��������       ����                            ����                                 ����                                 ����                    
   	   ����                          ����                                      ����      	      
                           ����                                             ����                                                                                  !      "                  #   #   ����             	       &   $   ����   %                                        
       (   '   ����   %                                    '          
          )   ����	   %                                           !      "                  .   *   ����          +      ,   !   -   "               /   /   ����   0   #             conn_count              conns               node_paths              editable_instances              version       {      RSRC��Gtp�extends Node3D

@onready var main_menu = $Menu

@onready var nicknamenp = $Menu/VBoxContainer/nicknamenp
@onready var colornp = $Menu/VBoxContainer/ColorRect/HBoxContainer/Panel/ColorPickerButton

const Player=preload("res://player.tscn")
const PORT=9999

var peer = WebSocketMultiplayerPeer.new()

func _init():
	peer.supported_protocols = ["ludus"]
	
func _on_joinbt_pressed():
	main_menu.hide()
	multiplayer.multiplayer_peer = null
	peer.create_client("ws://" + $Menu/VBoxContainer/addressinp.text + ":" + str(PORT))
	multiplayer.multiplayer_peer = peer
	
	Global.nickname=nicknamenp.text
	Global.color=colornp.color

�2�[remap]

path="res://.godot/exported/133200997/export-3070c538c03ee49b7677ff960a3f5195-main.scn"
a)U�FA�/z<�[remap]

path="res://.godot/exported/133200997/export-36a25e342948d0ceacc500772b5412b3-player.scn"
�%{�+��;t�?+list=Array[Dictionary]([{
"base": &"RefCounted",
"class": &"Gotm",
"icon": "",
"language": &"GDScript",
"path": "res://gotm/api/Gotm.gd"
}, {
"base": &"RefCounted",
"class": &"GotmAuth",
"icon": "",
"language": &"GDScript",
"path": "res://gotm/api/gotm_auth.gd"
}, {
"base": &"RefCounted",
"class": &"GotmBlob",
"icon": "",
"language": &"GDScript",
"path": "res://gotm/GotmBlob.gd"
}, {
"base": &"RefCounted",
"class": &"GotmConfig",
"icon": "",
"language": &"GDScript",
"path": "res://gotm/api/gotm_config.gd"
}, {
"base": &"RefCounted",
"class": &"GotmContent",
"icon": "",
"language": &"GDScript",
"path": "res://gotm/api/gotm_content.gd"
}, {
"base": &"RefCounted",
"class": &"GotmDebug",
"icon": "",
"language": &"GDScript",
"path": "res://gotm/GotmDebug.gd"
}, {
"base": &"RefCounted",
"class": &"GotmFile",
"icon": "",
"language": &"GDScript",
"path": "res://gotm/GotmFile.gd"
}, {
"base": &"RefCounted",
"class": &"GotmLeaderboard",
"icon": "",
"language": &"GDScript",
"path": "res://gotm/api/gotm_leaderboard.gd"
}, {
"base": &"RefCounted",
"class": &"GotmLobby",
"icon": "",
"language": &"GDScript",
"path": "res://gotm/GotmLobby.gd"
}, {
"base": &"RefCounted",
"class": &"GotmLobbyFetch",
"icon": "",
"language": &"GDScript",
"path": "res://gotm/GotmLobbyFetch.gd"
}, {
"base": &"RefCounted",
"class": &"GotmMark",
"icon": "",
"language": &"GDScript",
"path": "res://gotm/api/gotm_mark.gd"
}, {
"base": &"RefCounted",
"class": &"GotmPeriod",
"icon": "",
"language": &"GDScript",
"path": "res://gotm/api/gotm_period.gd"
}, {
"base": &"RefCounted",
"class": &"GotmQuery",
"icon": "",
"language": &"GDScript",
"path": "res://gotm/api/gotm_query.gd"
}, {
"base": &"RefCounted",
"class": &"GotmScore",
"icon": "",
"language": &"GDScript",
"path": "res://gotm/api/gotm_score.gd"
}, {
"base": &"RefCounted",
"class": &"GotmUser",
"icon": "",
"language": &"GDScript",
"path": "res://gotm/api/gotm_user.gd"
}, {
"base": &"RefCounted",
"class": &"_Gotm",
"icon": "",
"language": &"GDScript",
"path": "res://gotm/api/_impl/_Gotm.gd"
}, {
"base": &"RefCounted",
"class": &"_GotmAuth",
"icon": "",
"language": &"GDScript",
"path": "res://gotm/api/_impl/_gotm_auth.gd"
}, {
"base": &"RefCounted",
"class": &"_GotmAuthLocal",
"icon": "",
"language": &"GDScript",
"path": "res://gotm/api/_impl/_gotm_auth_local.gd"
}, {
"base": &"RefCounted",
"class": &"_GotmBlob",
"icon": "",
"language": &"GDScript",
"path": "res://gotm/api/_impl/_gotm_blob.gd"
}, {
"base": &"RefCounted",
"class": &"_GotmBlobLocal",
"icon": "",
"language": &"GDScript",
"path": "res://gotm/api/_impl/_gotm_blob_local.gd"
}, {
"base": &"RefCounted",
"class": &"_GotmContent",
"icon": "",
"language": &"GDScript",
"path": "res://gotm/api/_impl/_gotm_content.gd"
}, {
"base": &"RefCounted",
"class": &"_GotmContentLocal",
"icon": "",
"language": &"GDScript",
"path": "res://gotm/api/_impl/_gotm_content_local.gd"
}, {
"base": &"RefCounted",
"class": &"_GotmDebugImpl",
"icon": "",
"language": &"GDScript",
"path": "res://gotm/_impl/_GotmDebugImpl.gd"
}, {
"base": &"RefCounted",
"class": &"_GotmImpl",
"icon": "",
"language": &"GDScript",
"path": "res://gotm/_impl/_GotmImpl.gd"
}, {
"base": &"RefCounted",
"class": &"_GotmImplUtility",
"icon": "",
"language": &"GDScript",
"path": "res://gotm/_impl/_GotmImplUtility.gd"
}, {
"base": &"RefCounted",
"class": &"_GotmLeaderboard",
"icon": "",
"language": &"GDScript",
"path": "res://gotm/api/_impl/_gotm_leaderboard.gd"
}, {
"base": &"RefCounted",
"class": &"_GotmMark",
"icon": "",
"language": &"GDScript",
"path": "res://gotm/api/_impl/_gotm_mark.gd"
}, {
"base": &"RefCounted",
"class": &"_GotmMarkLocal",
"icon": "",
"language": &"GDScript",
"path": "res://gotm/api/_impl/_gotm_mark_local.gd"
}, {
"base": &"RefCounted",
"class": &"_GotmPeriod",
"icon": "",
"language": &"GDScript",
"path": "res://gotm/api/_impl/_gotm_period.gd"
}, {
"base": &"RefCounted",
"class": &"_GotmQuery",
"icon": "",
"language": &"GDScript",
"path": "res://gotm/api/_impl/_gotm_query.gd"
}, {
"base": &"RefCounted",
"class": &"_GotmScore",
"icon": "",
"language": &"GDScript",
"path": "res://gotm/api/_impl/_gotm_score.gd"
}, {
"base": &"RefCounted",
"class": &"_GotmScoreLocal",
"icon": "",
"language": &"GDScript",
"path": "res://gotm/api/_impl/_gotm_score_local.gd"
}, {
"base": &"RefCounted",
"class": &"_GotmStore",
"icon": "",
"language": &"GDScript",
"path": "res://gotm/api/_impl/_gotm_store.gd"
}, {
"base": &"RefCounted",
"class": &"_GotmUser",
"icon": "",
"language": &"GDScript",
"path": "res://gotm/api/_impl/_gotm_user.gd"
}, {
"base": &"RefCounted",
"class": &"_GotmUserLocal",
"icon": "",
"language": &"GDScript",
"path": "res://gotm/_impl/_GotmUserLocal.gd"
}, {
"base": &"RefCounted",
"class": &"_GotmUtility",
"icon": "",
"language": &"GDScript",
"path": "res://gotm/api/_impl/_gotm_utility.gd"
}, {
"base": &"RefCounted",
"class": &"_LocalStore",
"icon": "",
"language": &"GDScript",
"path": "res://gotm/api/_impl/_local_store.gd"
}])
'h�|��w�
v3%<svg height="128" width="128" xmlns="http://www.w3.org/2000/svg"><g transform="translate(32 32)"><path d="m-16-32c-8.86 0-16 7.13-16 15.99v95.98c0 8.86 7.13 15.99 16 15.99h96c8.86 0 16-7.13 16-15.99v-95.98c0-8.85-7.14-15.99-16-15.99z" fill="#363d52"/><path d="m-16-32c-8.86 0-16 7.13-16 15.99v95.98c0 8.86 7.13 15.99 16 15.99h96c8.86 0 16-7.13 16-15.99v-95.98c0-8.85-7.14-15.99-16-15.99zm0 4h96c6.64 0 12 5.35 12 11.99v95.98c0 6.64-5.35 11.99-12 11.99h-96c-6.64 0-12-5.35-12-11.99v-95.98c0-6.64 5.36-11.99 12-11.99z" fill-opacity=".4"/></g><g stroke-width="9.92746" transform="matrix(.10073078 0 0 .10073078 12.425923 2.256365)"><path d="m0 0s-.325 1.994-.515 1.976l-36.182-3.491c-2.879-.278-5.115-2.574-5.317-5.459l-.994-14.247-27.992-1.997-1.904 12.912c-.424 2.872-2.932 5.037-5.835 5.037h-38.188c-2.902 0-5.41-2.165-5.834-5.037l-1.905-12.912-27.992 1.997-.994 14.247c-.202 2.886-2.438 5.182-5.317 5.46l-36.2 3.49c-.187.018-.324-1.978-.511-1.978l-.049-7.83 30.658-4.944 1.004-14.374c.203-2.91 2.551-5.263 5.463-5.472l38.551-2.75c.146-.01.29-.016.434-.016 2.897 0 5.401 2.166 5.825 5.038l1.959 13.286h28.005l1.959-13.286c.423-2.871 2.93-5.037 5.831-5.037.142 0 .284.005.423.015l38.556 2.75c2.911.209 5.26 2.562 5.463 5.472l1.003 14.374 30.645 4.966z" fill="#fff" transform="matrix(4.162611 0 0 -4.162611 919.24059 771.67186)"/><path d="m0 0v-47.514-6.035-5.492c.108-.001.216-.005.323-.015l36.196-3.49c1.896-.183 3.382-1.709 3.514-3.609l1.116-15.978 31.574-2.253 2.175 14.747c.282 1.912 1.922 3.329 3.856 3.329h38.188c1.933 0 3.573-1.417 3.855-3.329l2.175-14.747 31.575 2.253 1.115 15.978c.133 1.9 1.618 3.425 3.514 3.609l36.182 3.49c.107.01.214.014.322.015v4.711l.015.005v54.325c5.09692 6.4164715 9.92323 13.494208 13.621 19.449-5.651 9.62-12.575 18.217-19.976 26.182-6.864-3.455-13.531-7.369-19.828-11.534-3.151 3.132-6.7 5.694-10.186 8.372-3.425 2.751-7.285 4.768-10.946 7.118 1.09 8.117 1.629 16.108 1.846 24.448-9.446 4.754-19.519 7.906-29.708 10.17-4.068-6.837-7.788-14.241-11.028-21.479-3.842.642-7.702.88-11.567.926v.006c-.027 0-.052-.006-.075-.006-.024 0-.049.006-.073.006v-.006c-3.872-.046-7.729-.284-11.572-.926-3.238 7.238-6.956 14.642-11.03 21.479-10.184-2.264-20.258-5.416-29.703-10.17.216-8.34.755-16.331 1.848-24.448-3.668-2.35-7.523-4.367-10.949-7.118-3.481-2.678-7.036-5.24-10.188-8.372-6.297 4.165-12.962 8.079-19.828 11.534-7.401-7.965-14.321-16.562-19.974-26.182 4.4426579-6.973692 9.2079702-13.9828876 13.621-19.449z" fill="#478cbf" transform="matrix(4.162611 0 0 -4.162611 104.69892 525.90697)"/><path d="m0 0-1.121-16.063c-.135-1.936-1.675-3.477-3.611-3.616l-38.555-2.751c-.094-.007-.188-.01-.281-.01-1.916 0-3.569 1.406-3.852 3.33l-2.211 14.994h-31.459l-2.211-14.994c-.297-2.018-2.101-3.469-4.133-3.32l-38.555 2.751c-1.936.139-3.476 1.68-3.611 3.616l-1.121 16.063-32.547 3.138c.015-3.498.06-7.33.06-8.093 0-34.374 43.605-50.896 97.781-51.086h.066.067c54.176.19 97.766 16.712 97.766 51.086 0 .777.047 4.593.063 8.093z" fill="#478cbf" transform="matrix(4.162611 0 0 -4.162611 784.07144 817.24284)"/><path d="m0 0c0-12.052-9.765-21.815-21.813-21.815-12.042 0-21.81 9.763-21.81 21.815 0 12.044 9.768 21.802 21.81 21.802 12.048 0 21.813-9.758 21.813-21.802" fill="#fff" transform="matrix(4.162611 0 0 -4.162611 389.21484 625.67104)"/><path d="m0 0c0-7.994-6.479-14.473-14.479-14.473-7.996 0-14.479 6.479-14.479 14.473s6.483 14.479 14.479 14.479c8 0 14.479-6.485 14.479-14.479" fill="#414042" transform="matrix(4.162611 0 0 -4.162611 367.36686 631.05679)"/><path d="m0 0c-3.878 0-7.021 2.858-7.021 6.381v20.081c0 3.52 3.143 6.381 7.021 6.381s7.028-2.861 7.028-6.381v-20.081c0-3.523-3.15-6.381-7.028-6.381" fill="#fff" transform="matrix(4.162611 0 0 -4.162611 511.99336 724.73954)"/><path d="m0 0c0-12.052 9.765-21.815 21.815-21.815 12.041 0 21.808 9.763 21.808 21.815 0 12.044-9.767 21.802-21.808 21.802-12.05 0-21.815-9.758-21.815-21.802" fill="#fff" transform="matrix(4.162611 0 0 -4.162611 634.78706 625.67104)"/><path d="m0 0c0-7.994 6.477-14.473 14.471-14.473 8.002 0 14.479 6.479 14.479 14.473s-6.477 14.479-14.479 14.479c-7.994 0-14.471-6.485-14.471-14.479" fill="#414042" transform="matrix(4.162611 0 0 -4.162611 656.64056 631.05679)"/></g></svg>
�>   s����.k   res://icon.svgL�u)�p�   res://main.tscn�sa���M   res://player.tscn��b�IޜU�GECFG      application/config/name         Godot4Multiplayer      application/run/main_scene         res://main.tscn    application/config/features$   "         4.1    Forward Plus       application/config/icon         res://icon.svg     autoload/Global         *res://global.gd   input/forward�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   W   	   key_label             unicode    w      echo          script         input/backward�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   S   	   key_label             unicode    s      echo          script         input/right�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   D   	   key_label             unicode    d      echo          script      
   input/left�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   A   	   key_label             unicode    a      echo          script         input/shoot�              deadzone      ?      events              InputEventMouseButton         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          button_mask          position     iC  �A   global_position      oC  �B   factor       �?   button_index         canceled          pressed          double_click          script      #   rendering/renderer/rendering_method         gl_compatibilityL��ym��