module CardDrawer

    require 'prawn'
    require 'json'

    @@mypayload = {}

    @@card_rows_per_page = 5
    @@card_height = 144
    @@card_width = 267.5
    @@left_margin_of_number = 12
    @@left_margin_of_description = 25
    @@left_margin_of_prio = 160
    @@right_margin = 20
    @@y_position_of_top_number = 710
    @@y_position_of_top_description = 690

    def CardDrawer.nbr_cards_to_print
        # private
        @@mypayload.size
    end

    def CardDrawer.draw_page(pdf, starting_data_index)
        # private

        pdf.stroke_axis

        # Here we draw a page's worth of boxes
        [5, 4, 3, 2, 1].each do |page_row_from_bottom|
            pdf.bounding_box([0, page_row_from_bottom * @@card_height], :width => @@card_width, :height => @@card_height) do
                pdf.stroke_bounds
            end
            pdf.bounding_box([@@card_width, page_row_from_bottom * @@card_height], :width => @@card_width, :height => @@card_height) do
                pdf.stroke_bounds
            end
        end

        # Here we draw a page's worth of data

        data_index = starting_data_index
        p "Message 37: Number of cards to print: "
        p CardDrawer.nbr_cards_to_print
        p "Message 38: data_index " + data_index.to_s

        (0..(@@card_rows_per_page - 1)).each do |card_row|

            # card on left

            # Number

            pdf.text_box(@@mypayload[data_index.to_s]["lo_number"],
                :at =>[@@left_margin_of_number, @@y_position_of_top_number - card_row * @@card_height],
                :width => @@card_width - (@@left_margin_of_description + @@right_margin))

            # Priority

            pdf.text_box(@@mypayload[data_index.to_s]["priority"],
                :at =>[@@left_margin_of_prio, @@y_position_of_top_number - card_row * @@card_height],
                :width => @@card_width - (@@left_margin_of_prio + @@right_margin),
                :overflow => :shrink_to_fit,
                :align => :right)

            # Description

            pdf.text_box(@@mypayload[data_index.to_s]["card_description"],
                :at =>[@@left_margin_of_description, @@y_position_of_top_description - card_row * @@card_height],
                :width => @@card_width - (@@left_margin_of_description + @@right_margin))

            data_index += 1
            p "Message 53: data_index " + data_index.to_s
            if (data_index + 1) > CardDrawer.nbr_cards_to_print
                break
            end

            # card on right

            pdf.text_box(@@mypayload[data_index.to_s]["lo_number"],
                :at =>[@@left_margin_of_number + @@card_width, @@y_position_of_top_number - card_row * @@card_height],
                :width => @@card_width - (@@left_margin_of_description + @@right_margin))

            # Priority

            pdf.text_box(@@mypayload[data_index.to_s]["priority"],
                :at =>[@@left_margin_of_prio + @@card_width, @@y_position_of_top_number - card_row * @@card_height],
                :width => @@card_width - (@@left_margin_of_prio + @@right_margin),
                :overflow => :shrink_to_fit,
                :align => :right)

            pdf.text_box(@@mypayload[data_index.to_s]["card_description"],
                :at =>[@@left_margin_of_description + @@card_width, @@y_position_of_top_description - card_row * @@card_height],
                :width => @@card_width - (@@left_margin_of_description + @@right_margin))

            data_index += 1
            if (data_index + 1) > CardDrawer.nbr_cards_to_print
                break
            end
        end # (0.. card_rows_per_page - 1).each do
    end # self.draw_page

    def CardDrawer.generate_document(payload)
        # public
        #
        # payload is a hash, with number of entries
        # equal to the number of rows (excluding top row)
        # in the spreadsheet

        @@mypayload = payload
        filename = ::Rails.root.join('cards.pdf')
        number_of_pages = ((CardDrawer.nbr_cards_to_print - 1) / 10) + 1

        pdf_file = Prawn::Document.new
        starting_data_index = 0
        (1..number_of_pages).each do |page|
            CardDrawer.draw_page(pdf_file, starting_data_index)
            if page != number_of_pages
                pdf_file.start_new_page
                starting_data_index += 10
            end
        end
        pdf_file.render_file(filename)
        status = {:status => "Cards generated successfully."}
        status
    end  # generate_document

end