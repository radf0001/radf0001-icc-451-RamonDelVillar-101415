package com.example.prueba;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;
import androidx.recyclerview.widget.DiffUtil;
import androidx.recyclerview.widget.ListAdapter;
import androidx.recyclerview.widget.RecyclerView;
import com.example.prueba.dto.Product;
import com.squareup.picasso.Picasso;
import android.content.Intent;

public class ProductListAdapter extends ListAdapter<Product, ProductListAdapter.ProductViewHolder> {

    public static final String EXTRA_MESSAGE = "com.example.prueba.MESSAGE";

    public ProductListAdapter(DiffUtil.ItemCallback<Product> diffCallback) {
        super(diffCallback);
    }

    @Override
    public ProductViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        return ProductViewHolder.create(parent);
    }

    @Override
    public void onBindViewHolder(ProductViewHolder holder, int position) {
        Product current = getItem(position);
        holder.bind(current);
//        holder.itemView.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View view) {
//                Product tarea = (Product) .getTag();
//                Intent intent = new Intent(holder.itemView.getContext(), NeActivity.class);
//                intent.putExtra(EXTRA_MESSAGE, "(" + tarea.getThumbnail() + ")" + tarea.getId() + "\n"
//                        + tarea.getTitle() + "\n" + tarea.getBrand() + "\n" + tarea.getDescription() + "\n" + tarea.getCategory()+ "\n"
//                        + tarea.getDiscountPercentage() + "\n" + tarea.getPrice() + "\n" + tarea.getRating() + "\n" + tarea.getStock()+ "\n");
//                view.getContext().startActivity(intent);
//            }
//        });
    }

    public static class ProductDiff extends DiffUtil.ItemCallback<Product> {

        @Override
        public boolean areItemsTheSame(Product oldItem, Product newItem) {
            return oldItem == newItem;
        }

        @Override
        public boolean areContentsTheSame(Product oldItem, Product newItem) {
            return oldItem.getId().equals(newItem.getId());
        }
    }


    static class ProductViewHolder extends RecyclerView.ViewHolder {
        private final TextView titulo;
        private final TextView desc;
        private final ImageView iconImage;

        private ProductViewHolder(View itemView) {
            super(itemView);
            titulo = itemView.findViewById(R.id.textViewArticulo);
            iconImage = itemView.findViewById(R.id.imageView);
            desc = itemView.findViewById(R.id.textViewDescripcion);
        }

        public void bind(Product item) {
            titulo.setText(item.getTitle());
            desc.setText(item.getDescription());
            Picasso.get().load(item.getThumbnail()).into(iconImage);
        }

        static ProductViewHolder create(ViewGroup parent) {
            View view = LayoutInflater.from(parent.getContext())
                    .inflate(R.layout.recycler_item, parent, false);
            return new ProductViewHolder(view);
        }
    }
}
