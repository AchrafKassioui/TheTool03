//  Created by Achraf Kassioui on 25/8/2023.

import SwiftUI
import SpriteKit

class Composition: SKScene, UIGestureRecognizerDelegate {
    
    // general
    var intendedSceneSize: CGSize
    
    // main camera rig
    var initialCameraPosition: CGPoint?
    var initialCameraScale: CGFloat?
    var pinchLocationInScene: CGPoint?
    private let maximumCameraScale: CGFloat = 5.0
    private let minimumCameraScale: CGFloat = 0.25
    
    // inertia panning
    var panInertiaTimer: Timer?
    var panVelocity: CGPoint?
    var previousRecordedTranslation: CGPoint?
    var lastRecordedTranslation: CGPoint?
    
    // MARK: - init
    
    override init(size: CGSize) {
        self.intendedSceneSize = size
        super.init(size: size)
        setupScene()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupScene() {
        self.scaleMode = .resizeFill
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        //self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.backgroundColor = SKColor.lightGray
    }
    
    // MARK: - didMove
    
    override func didMove(to view: SKView) {
        setupView()
        setupMainCamera()
        setupGestureRecognizers()
        //spawnSprite(at: CGPoint(x: 0, y: 0))
        self.isPaused = true
        self.isPaused = false
    }
    
    private func setupView() {
        view?.showsFPS = true
        view?.showsNodeCount = true
    }
    
    private func setupMainCamera() {
        let camera = SKCameraNode()
        let viewSize = view?.bounds.size
        camera.xScale = (viewSize!.width / size.width)
        camera.yScale = (viewSize!.height / size.height)
        addChild(camera)
        scene?.camera = camera
    }
    
    private func setupGestureRecognizers() {
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(gesture:)))
        view?.addGestureRecognizer(pinchGestureRecognizer)
        pinchGestureRecognizer.delegate = self
        
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapGesture(gesture:)))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        view?.addGestureRecognizer(doubleTapGestureRecognizer)
        doubleTapGestureRecognizer.delegate = self
    }
    
    // MARK: - pinching
    
    @objc private func handlePinchGesture(gesture: UIPinchGestureRecognizer) {
        zoomCamera(gesture: gesture)
    }
    
    func zoomCamera(gesture: UIPinchGestureRecognizer) {
        guard let camera = camera else { return }
        
        switch gesture.state {
        case .began:
            initialCameraScale = camera.xScale
            
            // Calculate the pinch's midpoint in the scene
            let pinchMidpointInView = gesture.location(in: view)
            pinchLocationInScene = convertPoint(fromView: pinchMidpointInView)
            
        case .changed:
            guard let pinchLocationInScene = pinchLocationInScene, let initialCameraScale = initialCameraScale else { return }
            
            // Calculate the new scale based directly on the gesture's scale
            var newScale = initialCameraScale / gesture.scale
            
            if newScale >= maximumCameraScale {
                newScale = maximumCameraScale
            } else if newScale <= minimumCameraScale {
                newScale = minimumCameraScale
            }
            
            // Calculate the zoom factor based on the new scale relative to the initial scale
            let zoomFactor = newScale / camera.xScale
            
            // Calculate the new camera position
            let newCamPosX = pinchLocationInScene.x + (camera.position.x - pinchLocationInScene.x) * zoomFactor
            let newCamPosY = pinchLocationInScene.y + (camera.position.y - pinchLocationInScene.y) * zoomFactor
            
            // Update camera's position and scale
            camera.position = CGPoint(x: newCamPosX, y: newCamPosY)
            camera.xScale = newScale
            camera.yScale = newScale
            
        default:
            pinchLocationInScene = nil
        }
    }
    
    @objc private func handleDoubleTapGesture(gesture: UITapGestureRecognizer) {
        resetCamera()
    }
    
    // MARK: - reset camera
    
    func resetCamera() {
        guard let camera = camera else { return }
        
        let scaleAction = SKAction.scale(to: 1.0, duration: 0.3)
        scaleAction.timingMode = .easeInEaseOut
        
        let moveAction = SKAction.move(to: CGPoint.zero, duration: 0.3)
        moveAction.timingMode = .easeInEaseOut
        
        let groupActions = SKAction.group([scaleAction, moveAction])
        camera.run(groupActions)
    }
    
    // MARK: - touch
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    // MARK: - update
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    // MARK: - Node creation
    
    func spawnSprite() {
        //print("SpriteKit\(SUIposition)")
        //let SKPosition = convertPoint(fromView point: SUIposition)
        
        let sprite = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))
        sprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        sprite.position = CGPoint(x: 0, y: 0)
        sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
        addChild(sprite)
        sprite.physicsBody?.angularDamping = 0.1
        sprite.physicsBody?.linearDamping = 1
        //sprite.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 10))
        sprite.physicsBody!.applyTorque(-1.0)
    }
    
}

// MARK: - SwiftUI

struct ContentView: View {
    
    var myComposition = Composition(size: CGSize(width: 4000, height: 4000))
    
    @State private var buttonPosition: CGPoint? = nil
    
    var body: some View {
        ZStack {
            SpriteView(scene: myComposition)
                .ignoresSafeArea()
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    Image(systemName: "plus")
                        .hoverEffect(/*@START_MENU_TOKEN@*/.automatic/*@END_MENU_TOKEN@*/)
                        .font(.title)
                        .padding()
                        .foregroundColor(.black)
                        .background(Circle().fill(Color.white).overlay(Circle().stroke(Color.black, lineWidth: 2)))
                        .position(buttonPosition ?? CGPoint(x: UIScreen.main.bounds.width - 80, y: UIScreen.main.bounds.height - 150))
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    self.buttonPosition = gesture.location
                                }
                                .onEnded { gesture in
                                    print("SwiftUI\(gesture.location)")
                                    myComposition.spawnSprite()
                                    withAnimation(.spring(response: 0.2, dampingFraction: 0.7)) {
                                        self.buttonPosition = nil
                                    }
                                }
                        )
                }
                .padding()
            }
        }
    }
}

#Preview {
    ContentView()
}
