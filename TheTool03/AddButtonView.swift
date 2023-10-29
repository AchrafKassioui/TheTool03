import SwiftUI
import SpriteKit

struct AddButtonView: View {
	@State private var dragOffset = CGSize.zero
	@State private var isDragging = false
	@State private var releasePosition: CGPoint?
	
	var body: some View {
		let drag = DragGesture()
			.onChanged { value in
				self.dragOffset = value.translation
				self.isDragging = true
			}
			.onEnded { value in
				print(value.location)
				self.isDragging = false
				// self.releasePosition = ?
				withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
					self.dragOffset = .zero
				}
				
				// Check if the button has been released over a specific view (SpriteView)
				// Here, you'd use the releasePosition to calculate whether it's within the bounds of your target view
				// For now, I'm using a simple print statement for demonstration purposes
			}
		
		let tap = TapGesture()
			.onEnded {
				// This will be triggered if the view is simply tapped (and not dragged)
				if !isDragging {
					print("Button was tapped!")
					// Trigger floating menu display logic here
				}
			}
		
		Image(systemName: "plus")
			.font(.system(size: 25))
			.padding()
			.background(Circle().fill(Color.white).overlay(Circle().stroke(Color.black, lineWidth: 2)))
			.offset(dragOffset)
			.gesture(tap)
			.gesture(drag)
	}
}

