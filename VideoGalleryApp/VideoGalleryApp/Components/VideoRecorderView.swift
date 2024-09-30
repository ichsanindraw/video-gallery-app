//
//  VideoRecorderView.swift
//  VideoGalleryApp
//
//  Created by Ichsan Indra Wahyudi on 30/09/24.
//

import AlertToast
import AVFoundation
import UIKit
import SwiftUI

struct VideoRecorderView: View {
//    private var topSafeAreaHeight: CGFloat {
//        UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
//    }
    
    @StateObject private var viewModel = VideoRecorderViewModel()
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var videoRecorder = VideoRecorder()

    var body: some View {
    
        ZStack {
            VStack(alignment: .center) {
                CameraPreview(captureSession: $videoRecorder.captureSession)
                    .edgesIgnoringSafeArea(.all)
                
                Button(action: {
                    withAnimation(.spring()) {
                        if videoRecorder.isRecording {
                            videoRecorder.stopRecording()
                        } else {
                            videoRecorder.startRecording()
                        }
                    }
                }) {
                    ZStack {
                        // Outer circle
                        Circle()
                            .fill(videoRecorder.isRecording ? Color.red : Color.gray.opacity(0.3))
                            .frame(width: 80, height: 80)
                        
                        // Inner circle
                        Circle()
                            .fill(videoRecorder.isRecording ? Color.red : Color.white)
                            .frame(width: videoRecorder.isRecording ? 30 : 50, height: videoRecorder.isRecording ? 30 : 50)
                    }
                }
                
                Spacer()
            }
            
            VStack {
                HStack(spacing: 8) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.largeTitle)
                            .padding()
                            .foregroundColor(.white)
                    }
                    Text("Record Video")
                    Spacer()
                }
                Spacer()
            }
        }
        .toast(isPresenting:  $viewModel.isShowingToast, alert: {
            var type: AlertToast.AlertType = .regular
            var title: String = ""
            var titleColor: Color? = .white
            var backgroundColor: Color?
            
            switch viewModel.toastState {
            case .loading:
                type = .loading
                title = "Uploading video..."
                titleColor = nil
                backgroundColor = nil
               
            case .success:
                title = "Successfully upload the video."
                backgroundColor = .green
                
            case .error:
                title = "Failed to upload the video."
                backgroundColor = .red
                
            case .idle:
                break
            }
            
            return AlertToast(
                displayMode: .hud,
                type: type,
                title: title,
                style: .style(
                    backgroundColor: backgroundColor,
                    titleColor: titleColor,
                    subTitleColor: nil,
                    titleFont: nil,
                    subTitleFont: nil
                )
            )
        })
        .alert(isPresented: $videoRecorder.isFinishRecorded) {
            Alert(
                title: Text("Upload Video"),
                message: Text("Would you like to upload this video?"),
                primaryButton: .default(Text("Upload")) {
                    if let fileURL = $videoRecorder.fileURL.wrappedValue {
                        viewModel.uploadVideo(fileURL: fileURL)
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }
}

struct CameraPreview: UIViewControllerRepresentable {
    @Binding var captureSession: AVCaptureSession?

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        previewLayer.frame = viewController.view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        viewController.view.layer.addSublayer(previewLayer)
        
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if let captureSession = captureSession {
            let previewLayer = uiViewController.view.layer.sublayers?.compactMap { $0 as? AVCaptureVideoPreviewLayer }.first
            previewLayer?.session = captureSession
        }
    }
}

class VideoRecorder: NSObject, ObservableObject {
    @Published var captureSession: AVCaptureSession?
    private var videoOutput: AVCaptureMovieFileOutput?
    
    @Published var isRecording = false
    @Published var showAlert = false
    @Published var isFinishRecorded = false
    @Published var fileURL: URL?
    var errorMessage = ""

    override init() {
        super.init()
        checkCameraAuthorization()
    }

    private func checkCameraAuthorization() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCaptureSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.setupCaptureSession()
                    }
                } else {
                    self.errorMessage = "Camera access was denied."
                    self.showAlert = true
                }
            }
        case .denied:
            self.errorMessage = "Camera access was denied."
            self.showAlert = true
        case .restricted:
            self.errorMessage = "Camera access is restricted."
            self.showAlert = true
        default:
            break
        }
    }

    private func setupCaptureSession() {
        let session = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            print("No video device available")
            return
        }

        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            print("Error creating video input: \(error)")
            return
        }

        if session.canAddInput(videoInput) {
            session.addInput(videoInput)
        } else {
            print("Could not add video input to session")
            return
        }

        videoOutput = AVCaptureMovieFileOutput()
        if session.canAddOutput(videoOutput!) {
            session.addOutput(videoOutput!)
        } else {
            print("Could not add video output to session")
            return
        }

        self.captureSession = session
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession?.startRunning()
        }
    }

    func startRecording() {
        isFinishRecorded = false
        
        guard let videoOutput = videoOutput else { return }

        let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("mov")
        videoOutput.startRecording(to: outputURL, recordingDelegate: self)
        isRecording = true
    }

    func stopRecording() {
        guard isRecording else { return }
        videoOutput?.stopRecording()
        isRecording = false
    }
}

extension VideoRecorder: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            errorMessage = error.localizedDescription
            showAlert = true
            return
        }
        
        isFinishRecorded = true
        fileURL = outputFileURL

        print("Video recorded to: \(outputFileURL)")
    }
}
