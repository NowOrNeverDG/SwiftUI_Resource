//
//  HScrollViewController.swift
//  MrPoDemo
//
//  Created by Ge Ding on 2/16/21.
//

import SwiftUI

struct HScrollViewController<Content: View>: UIViewControllerRepresentable {
    let pageWidth: CGFloat
    let contentSize: CGSize
    let content: Content
    @Binding var leftPercent: CGFloat
    
    init(pageWidth: CGFloat,
        contentSize: CGSize,
        leftPercent: Binding<CGFloat>,
        @ViewBuilder content: () -> Content) {
        self.pageWidth = pageWidth
        self.contentSize = contentSize
        self.content = content()
        self._leftPercent = leftPercent
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let scrollView = UIScrollView()
        
        scrollView.bounces = false//回弹效果
        scrollView.isPagingEnabled = true//分页效果
        scrollView.showsVerticalScrollIndicator = false//竖向滚动条
        scrollView.showsHorizontalScrollIndicator = false//横向滚动条
        scrollView.delegate = context.coordinator
        context.coordinator.scrollView = scrollView
        
        let vc = UIViewController()
        vc.view.addSubview(scrollView)
        
        let host = UIHostingController(rootView: content)
        vc.addChild(host)
        scrollView.addSubview(host.view)
        host.didMove(toParent: vc)//告诉host他已经添加到vc
        context.coordinator.host = host
        return vc
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self) 
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        let scrollView = context.coordinator.scrollView!
        scrollView.frame = CGRect(x: 0, y: 0, width: pageWidth, height: contentSize.height)
        scrollView.contentSize = contentSize
        scrollView.setContentOffset(CGPoint(x: leftPercent*(contentSize.width - pageWidth), y: 0), animated: true)
        context.coordinator.host.view.frame = CGRect(origin: .zero, size: contentSize )
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {//class和struct的重要区别之一：能否继承
        let parent: HScrollViewController
        var scrollView: UIScrollView!
        var host: UIHostingController<Content>!
        
        init(_ parent: HScrollViewController) {
            self.parent = parent
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            withAnimation {
                parent.leftPercent = scrollView.contentOffset.x < parent.pageWidth * 0.5 ? 0:1
            }
        }
    }
}
