///// Copyright (c) 2017 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation

class RestaurantDetailPresenter {
	weak var restaurantDetailView: RestaurantDetailCommandListenerProtocol? = nil
	private let detailInteractor: RestaurantDetailInteractorProtocol
	let detailId: String

	init(detailId: String, interactor: RestaurantDetailInteractorProtocol) {
		self.detailId = detailId
		self.detailInteractor = interactor
	}
}

extension RestaurantDetailPresenter: RestauranDetailPresenterProtocol {
	var interactor: RestaurantDetailInteractorProtocol {
		return self.detailInteractor
	}
	
	var commandListener: RestaurantDetailCommandListenerProtocol? {
		get {
			return self.restaurantDetailView
		}
		set {
			self.restaurantDetailView = newValue
		}
	}

	func handle(event: RestaurantDetailViewEvent) {
		switch event {
		case .viewDidLoad:
			self.interactor.handle(request: .fetchDetail(id: self.detailId))
		}
	}
}

extension RestaurantDetailPresenter: RestaurantDetailInteractorListenerProtocol {
	func handle(response: RestaurantDetailInteractorResponse) {
		switch response {
		case .didFetchRestaurantDetail(let result):
			self.handleFetchDetailDone(result: result)

		}
	}
	
	func handleFetchDetailDone(result: ServiceResult<RestaurantDetail>) {
		switch result {
		case .success(let detail):
			let viewModel = RestaurantDetailViewModel(restaurantDetail: detail)
			self.restaurantDetailView?.handle(
				command: RestaurantDetailPresenterCommand.populateDetail(viewModel: viewModel))

		case .failure(let error):
			self.restaurantDetailView?.handle(command:
				RestaurantDetailPresenterCommand.showError(
					title: error.title,
					message: error.errorDescription ?? "Error"))
		}
	}
}
