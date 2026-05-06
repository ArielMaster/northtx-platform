class ReceiptsController < ApplicationController
  def show
    @receipt = Receipt.find(params[:id])
    @user    = @receipt.user
    @plan    = @receipt.plan

    respond_to do |format|
      format.html
      format.pdf do
        pdf = render_to_string(
          template: "receipts/show",
          layout: "pdf",
          formats: [:html]
        )

        send_data pdf,
          filename: "receipt-#{@receipt.id}.pdf",
          type: "application/pdf",
          disposition: "attachment"
      end
    end
  end
end
