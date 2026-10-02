extends Adivery
#
## ساخت تبلیغ بازشدن اپلیکیشن 
#@onready var app_open_advertisement:= AppOpenAdvertisement.new()
## ساخت تبلیغ میان صفحه ای 
#@onready var interstitial_advertisement:= InterstitialAdvertisement.new()
# ساخت تبلیغ جایزه ای 
@onready var rewarded_advertisement:= RewardedAdvertisement.new()

var calleble : Callable

func _ready() -> void:
	app_id = "d91b2b93-2d14-426f-8ecc-937910e4c406"
	configure()
	#SetAppOpenAds()
	#SetInterstitialAds()
	SetRewardedAds()

#func SetAppOpenAds() -> void: 
	#app_open_advertisement.placement_id = "06b1884a-d04c-48f1-b8bc-27ee844eef93"
	#app_open_advertisement.show_on_resume = false
	#app_open_advertisement.name = "تبلیغ باز شدن اپ"
	#add_advertisement(app_open_advertisement)
	#prepare_app_open_ad(app_open_advertisement)
	#app_open_ad_clicked.connect(_on_app_open_ad_clicked)
	#app_open_ad_closed.connect(_on_app_open_ad_closed)
	#app_open_ad_loaded.connect(_on_app_open_ad_loaded)
	#app_open_ad_shown.connect(_on_app_open_ad_shown)
#
#func _on_app_open_ad_clicked(advertisement: Advertisement) -> void:
	#pass
#
#func _on_app_open_ad_closed(advertisement: Advertisement) -> void:
	#pass
#
#func _on_app_open_ad_loaded(advertisement: Advertisement) -> void:
	#pass
#
#func _on_app_open_ad_shown(advertisement: Advertisement) -> void:
	#pass

#func SetInterstitialAds() -> void:
	#interstitial_advertisement.placement_id = "fd85c408-7468-4d9d-97af-c94ae9b07c43"
	#interstitial_advertisement.name = "تبلیغ میان صفحه ای "
	#add_advertisement(interstitial_advertisement)
	#prepare_interstitial_ad(interstitial_advertisement)
	#interstitial_ad_clicked.connect(_on_interstitial_ad_clicked)
	#interstitial_ad_closed.connect(_on_interstitial_ad_closed)
	#interstitial_ad_loaded.connect(_on_interstitial_ad_loaded)
	#interstitial_ad_shown.connect(_on_interstitial_ad_shown)
#
#func _on_interstitial_ad_clicked(advertisement: Advertisement) -> void:
	#pass # تبلیغ کلیک شد
#
#func _on_interstitial_ad_closed(advertisement: Advertisement) -> void:
	#pass # تبلیغ بسته شد
#
#func _on_interstitial_ad_loaded(advertisement: Advertisement) -> void:
	#pass # تبلیغ بارگیری شد
#
#func _on_interstitial_ad_shown(advertisement: Advertisement) -> void:
	#pass # تبلیغ نمایش داده شد

func SetRewardedAds() -> void:
	rewarded_advertisement.placement_id = "a2ef2700-a2d9-427b-a4ab-257f21877ff3"
	rewarded_advertisement.name = "تبلیغ جایزه ای"
	add_advertisement(rewarded_advertisement)
	request_rewarded_ad(rewarded_advertisement)
	rewarded_ad_clicked.connect(_on_rewarded_ad_clicked)
	rewarded_ad_closed.connect(_on_rewarded_ad_closed)
	rewarded_ad_loaded.connect(_on_rewarded_ad_loaded)
	rewarded_ad_shown.connect(_on_rewarded_ad_shown)

func _on_rewarded_ad_clicked(_advertisement: Advertisement) -> void:
	pass

func _on_rewarded_ad_closed(_advertisement: Advertisement, is_rewarded: bool) -> void:
	calleble.bind(is_rewarded).call()

func _on_rewarded_ad_loaded(_advertisement: Advertisement) -> void:
	pass

func _on_rewarded_ad_shown(_advertisement: Advertisement) -> void:
	pass
