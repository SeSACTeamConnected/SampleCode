//
//  Home.swift
//  RotationTutorial
//
//  Created by Nayeon Kim on 2023/05/31.
//

import SwiftUI
import SceneKit

struct Home: View {
    @State var scene: SCNScene? = .init(named: "Tree_average_bare.scn")
    @State var isVerticalLook: Bool = true
    @State var currentMission: String = "양치하기"
    @Namespace var animation
    
    @GestureState var offset: CGFloat = 0
    
    var body: some View {
        VStack {
            HeaderView()
            
            CustomSceneView(scene: $scene)
                .frame(height: 350)
                .padding(.top, -50)
                .padding(.bottom, -15)
                .zIndex(-10)
            
            CustomSeeker()
            
            TreePropertiesView()
        }
        .padding()
    }
    
    @ViewBuilder
    func TreePropertiesView() -> some View {
        VStack {
            VStack(alignment: .leading, spacing: 12) {
                Text("Tree")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                
                Text("180도 회전")
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                
                Label {
                    Text("챕터 1")
                        .fontWeight(.semibold)
                } icon: {
                    Image(systemName: "book.fill")
                }
                .foregroundColor(.yellow)
            }
//            .padding(.top, 30)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Mission")
                    .font(.title3.bold())
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        let missions = ["양치하기", "세수하기", "이부정리하기", "칭찬하기", "감사하기"]
                        ForEach(missions, id: \.self) { mission in
                            Text(mission)
                                .fontWeight(.semibold)
                                .foregroundColor(currentMission == mission ? .black : .white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 15)
                                .background {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .fill(.white.opacity(0.2))
                                        
                                        if currentMission == mission {
                                            RoundedRectangle(cornerRadius: 10, style:.continuous)
                                                .fill(.white)
                                                .matchedGeometryEffect(id: "TAB", in: animation)
                                        }
                                    }
                                }
                                .onTapGesture {
                                    withAnimation(.easeInOut) {
                                        currentMission = mission
                                    }
                                }
                        }
                    }
                }
            }
            .padding(.top, 10)
            
            HStack(alignment: .top) {
                Button {
                    
                } label: {
                    VStack(spacing: 12) {
                        Image(systemName: "tree.fill")
                        
                        Text("나의 정원")
                            .fontWeight(.semibold)
                            .padding(.top, 15)
                    }
                    .foregroundColor(.black)
                    .padding(18)
                    .background {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(.white)
                    }
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("OO아, 나는 오늘 본 네 모습은 절대 잊을 수 없을 거야. 힘들어도 최선을 다하는 너는 눈이 부시게 아름다웠어.")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                    
                    Button {

                    } label: {
                        Text("식물일지 작성하기")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    .padding(.top, 10)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
            }
            .padding(.top, 10)
        }
    }
    
    @ViewBuilder
    func CustomSeeker() -> some View {
        GeometryReader { _ in
            Rectangle()
                .trim(from: 0, to: 0.474)
                .stroke(.linearGradient(colors: [
                    .clear,
                    .clear,
                    .white.opacity(0.2),
                    .white.opacity(0.6),
                    .white,
                    .white.opacity(0.6),
                    .white.opacity(0.2),
                    .clear,
                    .clear
                ], startPoint: .leading, endPoint: .trailing), style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, miterLimit: 1, dash: [3], dashPhase: 1))
                .offset(x: offset)
                .overlay {
                    HStack(spacing: 3) {
                        Image(systemName: "arrowtriangle.left.fill")
                            .font(.caption)
                        
                        Image(systemName: "arrowtriangle.right.fill")
                            .font(.caption)
                    }
                    .foregroundColor(.black)
                    .padding(.horizontal, 7)
                    .padding(.vertical, 10)
                    .background {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.white)
                    }
                    .offset(y: -12)
                    .offset(x: offset)
                    .gesture(
                        DragGesture()
                            .updating($offset, body: { value, out, _ in
                                out = value.location.x - 20
                            })
                    )
                }
        }
        .frame(height: 20)
        .onChange(of: offset, perform: { newValue in
            rotateObject(animate: offset == offset)
        })
        .animation(.easeInOut(duration: 0.4), value: offset == .zero
        )
    }
    
    //MARK: Rotating 3D Object Programatically
    func rotateObject(animate: Bool = false) {
        if animate {
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.4
        }
        
        let newAngle = Float((offset * .pi) / 180)
        
        if isVerticalLook {
            scene?.rootNode.childNode(withName: "Root", recursively: true)?.eulerAngles.y = newAngle
        } else {
            scene?.rootNode.childNode(withName: "Root", recursively: true)?.eulerAngles.x = newAngle
        }
        
        if animate {
            SCNTransaction.commit()
        }
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        HStack {
            Button {
            } label: {
                Image(systemName: "arrow.left")
                    .font(.system(size: 16, weight: .heavy))
                    .foregroundColor(.white)
                    .frame(width: 42, height: 42)
                    .background {
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .fill(.white.opacity(0.2))
                    }
            }
            Spacer()
            Button {
                withAnimation(.easeOut) { isVerticalLook.toggle() }
            } label: {
                Image(systemName: "arrow.left.and.right.righttriangle.left.righttriangle.right.fill")
                    .font(.system(size: 16, weight: .heavy))
                    .foregroundColor(.white)
                    .rotationEffect(.init(degrees: isVerticalLook ? 0 : 90))

                    .frame(width: 42, height: 42)
                    .background {
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .fill(.white.opacity(0.2))
                    }
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
