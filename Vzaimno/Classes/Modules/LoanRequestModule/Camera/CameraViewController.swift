//
//  CameraViewController.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 16.07.2021.
//

import UIKit
import AVFoundation

protocol CameraViewProtocol: BaseViewProtocol {

}

class CameraViewController: BaseViewController {

	// MARK: - IBOutlets

	@IBOutlet weak var previewView: UIView!
	@IBOutlet weak var capturedImageView: UIImageView!
	@IBOutlet weak var frameImageView: UIImageView!
	@IBOutlet weak var torchButton: UIButton!

	@IBOutlet weak var buttonsContainerView: UIView!
	@IBOutlet weak var newPhotoButton: UIButton!
	@IBOutlet weak var continueButton: UIButton!

	// MARK: - Properties

	private var photoItem: Photo!
	private var completionHandler: ((UIImage) -> Void)?
	private var capturedImage = UIImage()

	private var captureSession : AVCaptureSession!

	private var backCamera : AVCaptureDevice!
	private var frontCamera : AVCaptureDevice!
	private var backInput : AVCaptureInput!
	private var frontInput : AVCaptureInput!

	private var previewLayer : AVCaptureVideoPreviewLayer!
	private var videoOutput : AVCaptureVideoDataOutput!

	private var takePicture = false
	private var backCameraOn = true

	// MARK: - LifeCycle

	static func controller(photo: Photo, completionHandler: @escaping ((UIImage) -> Void)) -> CameraViewController {
		let storyboard = UIStoryboard(name: "Camera", bundle: nil)
		let vc = storyboard.instantiateInitialViewController() as! CameraViewController
		vc.completionHandler = completionHandler
		vc.photoItem = photo
		return vc
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		configureAppearance()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		setNavigationBarStyleLight(false)
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		checkPermissions()
	}

	// MARK: - Private

	private func setFrameImage() {
		switch photoItem.id {
		case 1: frameImageView.image = #imageLiteral(resourceName: "selfieWithPasport")
		case 2, 28, 29, 30: frameImageView.image = #imageLiteral(resourceName: "defaultPasport")
		case 3:	frameImageView.image = #imageLiteral(resourceName: "pasportReg")
		case 4: frameImageView.image = #imageLiteral(resourceName: "sts")
		case 5:	frameImageView.image = #imageLiteral(resourceName: "stsBack")
		case 6: frameImageView.image = #imageLiteral(resourceName: "pts")
		case 32: frameImageView.image = #imageLiteral(resourceName: "drivingLicense")
		case 33: frameImageView.image = #imageLiteral(resourceName: "drivingLicenseBack")
		default: frameImageView.image = UIImage()
		}
	}

	private func configureAppearance() {
		navigationItem.title = photoItem.title
		view.backgroundColor = .black

		capturedImageView.isHidden = true
		buttonsContainerView.isHidden = true

		buttonsContainerView.layer.cornerRadius = 8
		newPhotoButton.setTitle("Переснять", for: .normal)
		continueButton.setTitle("Продолжить", for: .normal)
		continueButton.layer.cornerRadius = 8

		if self.photoItem.id == 1 {
			torchButton.isHidden = true
		}
	}

	private func setupAndStartCaptureSession() {
		DispatchQueue.global(qos: .userInitiated).async{
			self.captureSession = AVCaptureSession()
			self.captureSession.beginConfiguration()

			if self.captureSession.canSetSessionPreset(.photo) {
				self.captureSession.sessionPreset = .photo
			}
			self.captureSession.automaticallyConfiguresCaptureDeviceForWideColor = true

			self.setupInputs()

			DispatchQueue.main.async {
				self.setupPreviewLayer()
			}

			self.setupOutput()

			self.captureSession.commitConfiguration()
			self.captureSession.startRunning()

			if self.photoItem.id == 1 {
				self.switchCameraInput()
			}

			DispatchQueue.main.async {
				self.setFrameImage()
			}
		}
	}

	private func setupInputs() {
		if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
			backCamera = device
		} else {
			print("No back camera")
		}

		if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
			frontCamera = device
		} else {
			print("No back camera")
		}

		guard let bInput = try? AVCaptureDeviceInput(device: backCamera) else {
			print("could not create input device from back camera")
			return
		}
		backInput = bInput
		if !captureSession.canAddInput(backInput) {
			print("Could not add back camera input to capture session")
		}

		guard let fInput = try? AVCaptureDeviceInput(device: frontCamera) else {
			print("Could not create input device from front camera")
			return
		}
		frontInput = fInput
		if !captureSession.canAddInput(frontInput) {
			print("Could not add front camera input to capture session")
		}

		captureSession.addInput(backInput)
	}

	private func setupOutput() {
		videoOutput = AVCaptureVideoDataOutput()
		let videoQueue = DispatchQueue(label: "videoQueue", qos: .userInteractive)
		videoOutput.setSampleBufferDelegate(self, queue: videoQueue)

		if captureSession.canAddOutput(videoOutput) {
			captureSession.addOutput(videoOutput)
		} else {
			print("Could not add video output")
		}

		videoOutput.connections.first?.videoOrientation = .portrait
	}

	private func setupPreviewLayer(){
		previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)

		previewLayer.frame = previewView.bounds
		previewView.layer.addSublayer(previewLayer)
	}

	private func switchCameraInput() {
		captureSession.beginConfiguration()
		if backCameraOn {
			captureSession.removeInput(backInput)
			captureSession.addInput(frontInput)
			backCameraOn = false
		} else {
			captureSession.removeInput(frontInput)
			captureSession.addInput(backInput)
			backCameraOn = true
		}

		videoOutput.connections.first?.videoOrientation = .portrait
		videoOutput.connections.first?.isVideoMirrored = !backCameraOn
		captureSession.commitConfiguration()
	}

	private func checkPermissions() {
		let cameraAuthStatus =  AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
		switch cameraAuthStatus {
		case .authorized:
			setupAndStartCaptureSession()
			return
		case .denied:
			promptToAllowCameraAccessViaSetting()
		case .notDetermined:
			AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler:
											{ (authorized) in
												if(!authorized) {
													DispatchQueue.main.async {
														self.promptToAllowCameraAccessViaSetting()
													}
												} else {
													self.setupAndStartCaptureSession()
												}
											})
		case .restricted:
			promptToAllowCameraAccessViaSetting()
		@unknown default:
			return
		}
	}

	private func promptToAllowCameraAccessViaSetting() {
		let alert = UIAlertController(title: "Перейти в настройки", message: "Камера используется для фотографирования документов", preferredStyle: UIAlertController.Style.alert)

		alert.addAction(UIAlertAction(title: "Отменить", style: .default) { (alert) -> Void in
			DispatchQueue.main.async {
				self.navigationController?.popViewController(animated: true)
			}
		})
		alert.addAction(UIAlertAction(title: "Настройки", style: .cancel) { (alert) -> Void in
			if let settingsUrl = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(settingsUrl) {
				UIApplication.shared.open(settingsUrl)
			}
		})

		present(alert, animated: true)
	}

	// MARK: - IBActions

	@IBAction func torchButtonAction(_ sender: Any) {
		guard let device = AVCaptureDevice.default(for: AVMediaType.video), device.hasTorch else { return }

		do {
			try device.lockForConfiguration()

			if (device.torchMode == AVCaptureDevice.TorchMode.on) {
				device.torchMode = AVCaptureDevice.TorchMode.off
			} else {
				do {
					try device.setTorchModeOn(level: 1.0)
				} catch {
					print(error.localizedDescription)
				}
			}
			device.unlockForConfiguration()
		} catch {
			print(error.localizedDescription)
		}
	}

	@IBAction func cameraButtonAction(_ sender: Any) {
		takePicture = true
	}

	@IBAction func newPhotoButtonAction(_ sender: Any) {
		buttonsContainerView.isHidden = true
		capturedImageView.isHidden = true
	}

	@IBAction func continueButtonAction(_ sender: Any) {
		completionHandler?(capturedImage)
		navigationController?.popViewController(animated: true)
	}

}

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
	func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
		if !takePicture {
			return
		}
		guard let cvBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
			return
		}

		let uiImage = UIImage(ciImage: CIImage(cvImageBuffer: cvBuffer))

		DispatchQueue.main.async {
			self.capturedImageView.isHidden = false
			self.buttonsContainerView.isHidden = false

			self.capturedImageView.image = uiImage
			self.capturedImage = uiImage
			self.takePicture = false
		}
	}
}

extension CameraViewController: CameraViewProtocol {

}
